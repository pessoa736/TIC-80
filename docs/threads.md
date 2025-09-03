# Threads API (Virtual)

This fork adds a minimal, cross-language threads tool that lets you run scripts off the main VM. It’s designed for background work (AI, pathfinding, data prep) without blocking TIC.

Supported languages:
- Lua (full)
- JavaScript/QuickJS (full)
- Python/PocketPy (UNIX/macOS only in this fork; disabled on Android)

## API

- thread_run(lang, code_or_cart_path, [args...]) -> id
  - lang: "lua" | "js" | "python"
  - code_or_cart_path: string with source code or a path to a file/cart section depending on language support
  - returns integer id > 0 on success

- thread_poll(id) -> status, result
  - status: "running" | "done" | "error" | "invalid"
  - result: language-specific value when done, or error string when error

- thread_join(id [, timeout_ms]) -> status, result
  - Blocks (with optional timeout) until thread finishes or errors.

Notes:
- Each worker has an isolated runtime (new Lua state, new QuickJS runtime/context, or PocketPy VM).
- Workers cannot touch TIC state directly; use the Async TIC bridge below when needed.
- On Android, Python threads are disabled to keep the NDK surface minimal.

## Lua example
```lua
-- background compute in Lua
local id = thread_run("lua", [[
  -- heavy work
  local s = 0
  for i=1,2e6 do s = s + i end
  return s -- becomes the result
]])

function TIC()
  local st, res = thread_poll(id)
  if st == "done" then
    print("sum="..res, 10, 10, 12)
  elseif st == "error" then
    print("ERR:"..tostring(res), 10, 10, 2)
  else
    print("working...", 10, 10, 15)
  end
end
```

## JavaScript example
```js
let id = thread_run("js", `
  // heavy compute
  let s = 0; for (let i=1;i<=2_000_000;i++) s+=i; s; // last expr is result
`);

function TIC(){
  let [st, res] = thread_poll(id);
  if(st==="done") print("sum="+res,10,10,12);
  else if(st==="error") print("ERR:"+res,10,10,2);
  else print("working...",10,10,15);
}
```

## Error handling
- Errors in worker code surface as status "error" with the message/trace when available.
- Join on an invalid/non-existent id returns status "invalid".

## Performance tips
- Prefer a few long-lived workers over floods of short tasks.
- Avoid large string passing; use lightweight messages or precomputed numbers.
- Use the Async TIC bridge only for drawing/time/pmem etc.; keep main-thread rendering fast.
