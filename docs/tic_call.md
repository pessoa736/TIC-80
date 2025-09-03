# Async TIC bridge (tic_call)

Worker VMs can request a subset of TIC API calls to run on the main thread safely via a small async bridge.

Currently implemented for Lua workers in this fork.

## Contract
- From a worker, call: tic_call(name, ...)
- Returns: result(s) of the TIC call, or raises an error in worker if unsupported
- Calls are queued and executed on the main thread before each frame renders.

Supported names (subset):
- cls(c)
- trace(msg[, color])
- time()
- pmem(idx[, val])
- rect(x,y,w,h,color)
- line(x0,y0,x1,y1,color)
- pix(x,y[,color])
- print(text,x,y[,color]) -> width

Example (Lua worker):
```lua
thread_run("lua", [[
  for i=0,60 do
    tic_call('rect', i, i, 10, 10, 12)
  end
]])
```

Notes:
- The bridge is intentionally small. Extend cautiously.
- Calls are executed FIFO. Avoid flooding per-frame.
- If the bridge is not available (e.g., no Lua build), calls are no-ops and will error in the worker.
