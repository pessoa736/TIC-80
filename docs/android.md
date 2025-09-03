# Android build and runtime notes

## Building
- Native build is driven via Gradle from `build/android`.
- Uses NDK r21e-compatible flags in this fork; QuickJS and Lua are built as part of the tree.

Artifacts
- app/build/outputs/apk/release/app-release.apk
- native debug symbols: app/build/outputs/native-debug-symbols/release/...

## Virtual keyboard
- Rendered as a bottom overlay, independent of the logical screen size.
- Touch hit-testing uses the same rect math as rendering to stay aligned.
- If the OS IME is active, the overlay hides.

## Threads
- Lua and JS workers supported.
- Python (PocketPy) workers disabled on Android in this fork.

## Troubleshooting
- If input feels offset on high-DPI devices, confirm display scale and that both hit-testing and draw paths use identical rect.
- Clear app data between major updates to reset saved config.
