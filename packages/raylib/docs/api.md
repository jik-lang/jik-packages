# raylib API

This package exposes a small raylib 6.0 subset for basic 2D Jik programs.

```jik
use "pkg/raylib"
```

## Supported platform

`pkg/raylib` requires Jik 0.1.0-alpha.12 or newer. It supports Windows and
Linux x86-64 with MinGW-w64 GCC and GCC respectively. It bundles and statically
links raylib 6.0, so applications do not need a separate raylib library beside
the executable.

The wrapper exposes 2D windows, drawing, texture loading and drawing, input,
and short sound effects. It does not expose CPU-side raylib `Image` editing,
custom fonts, music streaming, or 3D APIs yet.

## Relationship to raylib

Use this document to determine what is available in Jik. The original raylib
references explain the underlying C library:

- [raylib 6.0 cheatsheet](https://www.raylib.com/cheatsheet/raylib_cheatsheet_v6.0.pdf)
- [official raylib examples](https://www.raylib.com/examples.html)
- [raylib 6.0 header](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h)
- [header bundled with this package](../native/raylib-6.0_win64_mingw-w64/include/raylib.h)

Only the Jik functions listed below are exposed. A function shown in the full
raylib cheatsheet is not available through `pkg/raylib` unless it also appears
here. Native function names in the tables link to their exact raylib 6.0
declarations.

The official examples are written in C and may use functions outside this
subset. Translate a C call to its Jik name only when the mapping is listed here.

Jik uses `snake_case` names and Jik-friendly types. The wrapper converts its
`double` coordinates to raylib `float` values and its integer color components
to native color bytes. Some operations also add region allocation, safe empty
handles, path lookup, or fixed defaults; those differences are noted below.

## Types

```jik
struct Vector2:
    x: double
    y: double
end

struct Color:
    r: int
    g: int
    b: int
    a: int
end

struct Rectangle:
    x: double
    y: double
    width: double
    height: double
end
```

These are Jik values converted at the native boundary; they are not binary
copies of raylib's C structs.

`Sound` and `Texture` are opaque handles for native raylib resources.
`Sound{}` and `Texture{}` create unloaded handles on which their resource
operations are safe no-ops. Loaded sounds and textures must still be released
explicitly with `unload_sound` and `unload_texture`.

## Constants

The package currently defines:

| Category | Constants |
|---|---|
| Colors | `WHITE`, `BLACK`, `RED`, `GREEN`, `BLUE`, `YELLOW`, `RAYWHITE`, `LIGHTGRAY`, `DARKGRAY` |
| Keys | `KEY_SPACE`, `KEY_W`, `KEY_S`, `KEY_ESCAPE`, `KEY_ENTER`, `KEY_LEFT`, `KEY_RIGHT`, `KEY_UP`, `KEY_DOWN` |
| Mouse buttons | `MOUSE_BUTTON_LEFT`, `MOUSE_BUTTON_RIGHT`, `MOUSE_BUTTON_MIDDLE` |

## Window and frame lifecycle

These operations come from raylib's `rcore` module.

| Jik API | Native raylib | Wrapper behavior |
|---|---|---|
| `init_window(width, height, title)` | [`InitWindow`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L986) | Passes the Jik string as the window title. |
| `close_window()` | [`CloseWindow`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L987) | Closes the window and graphics context. |
| `window_should_close() -> bool` | [`WindowShouldClose`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L988) | Direct semantic equivalent. |
| `is_window_ready() -> bool` | [`IsWindowReady`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L989) | Direct semantic equivalent. |
| `set_window_title(title)` | [`SetWindowTitle`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1006) | Passes a Jik string. |
| `get_screen_width() -> int` | [`GetScreenWidth`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1015) | Direct semantic equivalent. |
| `get_screen_height() -> int` | [`GetScreenHeight`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1016) | Direct semantic equivalent. |
| `begin_drawing()` | [`BeginDrawing`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1046) | Starts drawing a frame. |
| `end_drawing()` | [`EndDrawing`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1047) | Finishes and presents the frame. |
| `set_target_fps(fps)` | [`SetTargetFPS`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1092) | Sets simple frame limiting. |
| `get_frame_time() -> double` | [`GetFrameTime`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1093) | Widens the native `float` result to `double`. |
| `get_time() -> double` | [`GetTime`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1094) | Direct semantic equivalent. |
| `get_fps() -> int` | [`GetFPS`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1095) | Direct semantic equivalent. |

A minimal frame loop is:

```jik
raylib::init_window(800, 450, "Jik and raylib")
raylib::set_target_fps(60)

while not raylib::window_should_close():
    raylib::begin_drawing()
    raylib::clear_background(raylib::RAYWHITE)
    raylib::end_drawing()
end

raylib::close_window()
```

## Drawing

Shape operations correspond to raylib's `rshapes` module. Text operations
correspond to `rtext`.

| Jik API | Native raylib | Wrapper behavior |
|---|---|---|
| `clear_background(color)` | [`ClearBackground`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1045) | Converts the Jik color. |
| `draw_pixel(position, color)` | [`DrawPixel`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1273) | Converts the position components to integer pixels. |
| `draw_line(start, finish, color)` | [`DrawLineV`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1276) | Converts two Jik vectors to native vectors. |
| `draw_rectangle(rectangle, color)` | [`DrawRectangleRec`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1296) | Converts the Jik rectangle. |
| `draw_rectangle_lines(rectangle, color)` | [`DrawRectangleLinesEx`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1302) | Uses a fixed native line thickness of `1.0`. |
| `draw_circle(center, radius, color)` | [`DrawCircleV`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1282) | Uses the vector form and converts the radius to `float`. |
| `draw_circle_lines(center, radius, color)` | [`DrawCircleLinesV`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1287) | Uses the vector outline form. |
| `draw_text(text, x, y, size, color)` | [`DrawText`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1503) | Draws with raylib's default font. |
| `measure_text(text, size) -> int` | [`MeasureText`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1511) | Measures text drawn with the default font. |

For example, `draw_circle` wraps `DrawCircleV`, not `DrawCircle`, because the
Jik API accepts a `Vector2` center:

```jik
center := raylib::Vector2{x = 400.0, y = 225.0}
raylib::draw_circle(center, 30.0, raylib::BLUE)
```

## Textures

Texture operations load an image file directly into GPU texture memory. PNG is
supported, along with the other file types supported by the bundled raylib
build. The wrapper does not expose CPU-side `Image` data or image editing.

| Jik API | Native raylib | Wrapper behavior |
|---|---|---|
| `Texture{}` | None | Creates an unloaded opaque texture handle. |
| `load_texture(path, region) -> Texture` | [`LoadTexture`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1441) | Loads the path after a window is initialized. If the path is not found from the working directory, also tries beside the executable. |
| `is_texture_valid(texture) -> bool` | [`IsTextureValid`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1445) | Reports whether the texture loaded successfully. |
| `texture_width(texture) -> int` | `Texture2D.width` | Returns zero for an unloaded texture. |
| `texture_height(texture) -> int` | `Texture2D.height` | Returns zero for an unloaded texture. |
| `set_texture_filter_point(texture)` | [`SetTextureFilter`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1454) | Sets nearest-neighbour filtering for crisp pixel-art scaling. |
| `draw_texture_rect(texture, source, destination, tint)` | [`DrawTexturePro`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1462) | Draws a source rectangle from the texture into a destination rectangle. `WHITE` keeps the original colors. |
| `unload_texture(texture)` | [`UnloadTexture`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1446) | Releases a valid texture once and marks the shared handle invalid. |

Load textures after `init_window` and unload them before `close_window`:

```jik
texture := raylib::load_texture("assets/tiles.png", _)
if raylib::is_texture_valid(texture):
    raylib::set_texture_filter_point(texture)
end

while not raylib::window_should_close():
    raylib::begin_drawing()
    raylib::clear_background(raylib::BLACK)
    raylib::draw_texture_rect(
        texture,
        raylib::Rectangle{x = 0.0, y = 0.0, width = 16.0, height = 16.0},
        raylib::Rectangle{x = 80.0, y = 80.0, width = 64.0, height = 64.0},
        raylib::WHITE)
    raylib::end_drawing()
end

raylib::unload_texture(texture)
```

The `source` rectangle enables spritesheets: change its `x` and `y` values to
select an animation frame, then choose the scaled on-screen size through the
`destination` rectangle.

## Input

Input operations come from raylib's `rcore` module.

| Jik API | Native raylib | Wrapper behavior |
|---|---|---|
| `is_key_pressed(key) -> bool` | [`IsKeyPressed`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1198) | Reports a single press event. |
| `is_key_down(key) -> bool` | [`IsKeyDown`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1200) | Reports whether the key is held. |
| `is_key_released(key) -> bool` | [`IsKeyReleased`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1201) | Reports a single release event. |
| `is_key_up(key) -> bool` | [`IsKeyUp`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1202) | Reports whether the key is not held. |
| `is_mouse_button_pressed(button) -> bool` | [`IsMouseButtonPressed`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1222) | Reports a single press event. |
| `is_mouse_button_down(button) -> bool` | [`IsMouseButtonDown`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1223) | Reports whether the button is held. |
| `get_mouse_position(region) -> Vector2` | [`GetMousePosition`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1228) | Allocates a Jik `Vector2` in the supplied region and widens its components to `double`. |
| `get_mouse_wheel_move() -> double` | [`GetMouseWheelMove`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1233) | Widens the native `float` result to `double`. |

## Audio

Audio operations correspond to raylib's `raudio` module and currently support
short sound effects, not music streaming.

| Jik API | Native raylib | Wrapper behavior |
|---|---|---|
| `Sound{}` | None | Creates an unloaded region-allocated handle. |
| `init_audio_device()` | [`InitAudioDevice`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1662) | Initializes the native audio device and context. |
| `close_audio_device()` | [`CloseAudioDevice`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1663) | Closes the native audio device and context. |
| `is_audio_device_ready() -> bool` | [`IsAudioDeviceReady`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1664) | Direct semantic equivalent. |
| `load_sound(path, region) -> Sound` | [`LoadSound`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1672), [`IsSoundValid`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1675) | Creates an opaque handle and records whether loading succeeded. |
| `is_sound_valid(sound) -> bool` | [`IsSoundValid`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1675) | Reports the validity recorded when the wrapper loaded the sound. |
| `play_sound(sound)` | [`PlaySound`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1684) | Plays valid handles; invalid handles are no-ops. |
| `set_sound_volume(sound, volume)` | [`SetSoundVolume`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1689) | Converts the Jik `double` volume to native `float`; invalid handles are no-ops. |
| `unload_sound(sound)` | [`UnloadSound`](https://github.com/raysan5/raylib/blob/6.0/src/raylib.h#L1678) | Unloads a valid sound once and marks the shared handle invalid. |

Initialize the audio device before loading sounds. Unload every loaded sound
before closing the audio device. If the device or sound file is unavailable,
the returned handle is invalid and playback is a no-op.

Copies of a `Sound` value refer to the same opaque handle. Unloading through
one copy also invalidates the other copies.

## Native build

The package includes raylib 6.0 for Windows/MinGW and Linux/GCC and declares
its include path, library path, and linker requirements. Programs importing
`pkg/raylib` can be built or run directly:

```sh
jik build app.jik
jik run app.jik
```

Raylib is linked statically, so the resulting program does not require a
separate raylib library at runtime. MinGW-w64 GCC and Linux GCC are the
supported compilers.

The bundled native distribution is covered by the
[raylib license](../native/raylib-6.0_win64_mingw-w64/LICENSE).
