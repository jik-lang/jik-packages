# Missile Defence

A small vector-graphics Missile Defence-style game built with Jik and `pkg/raylib`.

It requires Windows or Linux x86-64 with MinGW-w64 GCC or GCC respectively.

The showcase includes:

- title, play, pause, wave, game-over, restart, and return-to-menu states
- mouse targeting and battery selection
- player and enemy missile movement based on frame time
- expanding explosions and chained interceptions
- destructible cities and batteries
- score, ammunition, four clearly differentiated difficulty levels, and increasing wave speed
- bounded reusable pools for missiles and explosions
- original launch, explosion, and impact sound effects

## Run

From the `jik-packages` repository root, with `JIK_PKG_PATH` pointing to that root:

```sh
jik run packages/raylib/examples/missile_defence/main.jik
```

To keep the executable beside the `assets/` directory:

```sh
jik build packages/raylib/examples/missile_defence/main.jik
```

When using `jik build --out` to place the executable elsewhere, copy `assets/`
beside that executable so the sound effects can be loaded.


## Controls

- Left/Right: choose Easy, Normal, Hard, or Expert on the title screen
- Enter or Space: start or restart
- P: pause or resume a game
- M: return to the main menu from a game, pause screen, or game-over screen
- Mouse: aim
- Left mouse button: launch from the nearest living battery with ammunition
- Escape or the window close button: exit

Shots below the sky are ignored. Each living battery is refilled at the start
of a wave. Difficulty changes enemy speed, wave growth, enemy count, spawn rate,
player missile speed, and ammunition: Easy is forgiving, while Expert starts
with a larger, faster barrage and only six missiles per battery.
