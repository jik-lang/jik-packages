# Missile Defence

A small vector-graphics Missile Defence-style game built with Jik and `pkg/raylib`.

It requires Windows or Linux x86-64 with MinGW-w64 GCC or GCC respectively.

The showcase includes:

- title, play, wave, game-over, and restart states
- mouse targeting and battery selection
- player and enemy missile movement based on frame time
- expanding explosions and chained interceptions
- destructible cities and batteries
- score, ammunition, four difficulty levels, and increasing wave speed
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
- Mouse: aim
- Left mouse button: launch from the nearest living battery with ammunition
- Escape or the window close button: exit

Shots below the sky are ignored. Each living battery is refilled at the start
of a wave. Each wave makes enemy and player missiles faster. Enemy speed grows
faster, with the selected difficulty setting changing their starting speed and
growth rate.
