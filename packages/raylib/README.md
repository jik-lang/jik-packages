# raylib

Small 2D raylib wrapper for Jik.


## Requirements

- Jik 0.1.0-alpha.12 or newer
- Windows or Linux x86-64
- MinGW-w64 GCC on Windows, or GCC on Linux

The bundled native distributions are raylib 6.0 for Windows/MinGW and
Linux/GCC. Raylib is linked statically, so no separate raylib library is
required beside the executable.

## Linux compatibility

The bundled Linux raylib 6.0 archive targets x86-64 GNU/Linux with glibc 2.38
or newer, such as Ubuntu 24.04. It does not currently link on older glibc
distributions, including Ubuntu 22.04.

Building Jik programs also requires GCC and the distribution's X11 development
package (`libx11-dev` on Debian and Ubuntu). At runtime, a graphical X11 or
XWayland session and an OpenGL driver are required.

## Scope

This package provides:

- window and frame lifecycle
- basic 2D drawing
- default-font text drawing and measurement
- keyboard and mouse polling
- short sound loading and playback
- common colors and input constants

It does not expose raylib image, texture, custom-font, music-streaming, or 3D
APIs.

Import it with:

```jik
use "pkg/raylib"
```

The package declares its native build requirements, so programs that import it
can be built or run directly:

```sh
jik build app.jik
jik run app.jik
```

## Quick start

Start with the basic window example:

```sh
jik run packages/raylib/examples/basic_window.jik
```

## Examples

### Input and animation

The small input and animation example demonstrates keyboard and mouse polling,
frame-time-based movement, and the basic drawing loop:

```sh
jik run packages/raylib/examples/input_and_animation.jik
```

### Pong

The self-contained two-player Pong example demonstrates keyboard-controlled
movement, collision detection, scoring, and restart behavior:

```sh
jik run packages/raylib/examples/pong.jik
```

### Missile Defence

The vector-graphics Missile Defence example exercises the game loop, mouse input,
frame-time-based movement, reusable entity pools, drawing, sound effects, scoring,
waves, and restart behavior:

```sh
jik run packages/raylib/examples/missile_defence/main.jik
```

Use the mouse to aim, left click to launch, and Enter or Space to start or restart.
See `examples/missile_defence/README.md` for details and test commands.

See [the API reference](docs/api.md) for the complete exposed API.

## Third-party software

The Jik wrapper is released under this repository's [MIT License](../../LICENSE).
The bundled raylib 6.0 native distribution is covered by the
[raylib license](native/raylib-6.0_win64_mingw-w64/LICENSE).
