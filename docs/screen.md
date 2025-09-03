# Screen, scaling, and input hit-testing

This fork uses a 480x270 logical display (2x the classic 240x136). Don’t hardcode dimensions. Use the constants from `include/tic80.h` or query at runtime.

## Constants
- TIC80_WIDTH, TIC80_HEIGHT: logical size
- TIC80_FULLWIDTH, TIC80_FULLHEIGHT: full framebuffer including margins
- TIC80_OFFSET_LEFT, TIC80_OFFSET_TOP: margins to center the logical area

## Runtime helper
```c
void tic80_get_screen_info(s32* w, s32* h, s32* fw, s32* fh, s32* bpp);
```
- Exposes sizes/bpp from the core to platform frontends.

## SDL frontend notes
- The Android virtual keyboard is drawn as an overlay pinned to the bottom.
- Hit-testing and render use the same computed destination rect to avoid drift across scales.
- Keep any new UI elements resolution-independent by using TIC80_* constants and proportional math.

## Game carts
- Most existing carts render fine thanks to consistent scaling.
- If you do any manual screen reads/writes, prefer `peek/poke` and constants to avoid hardcoded magic numbers.
