import gg
import gx
import math

const width  = 320
const height = 320

struct App {
	mut:
    cx int = width / 2
    cy int = height / 2
    r  int = if width / 2 < height / 2 { width / 2 } else { height / 2 }
}

fn hsv_to_rgb(h f32, s f32, v f32) gx.Color {
    c := v * s
    h_prime := h / 60.0
    x := c * (1 - math.abs(math.fmod(f64(h_prime), 2) - 1))
    m := v - c
    mut r, mut g, mut b := 0.0, 0.0, 0.0
    match int(h_prime) {
        0 { r, g, b = c, x, 0 }
        1 { r, g, b = x, c, 0 }
        2 { r, g, b = 0, c, x }
        3 { r, g, b = 0, x, c }
        4 { r, g, b = x, 0, c }
        5, 6 { r, g, b = c, 0, x }
        else { r, g, b = 0, 0, 0 }
    }
    rrr := u8(math.min((r + m) * 255, 255))
    ggg := u8(math.min((g + m) * 255, 255))
    bbb := u8(math.min((b + m) * 255, 255))
    return gx.rgb(rrr, ggg, bbb)
}

fn main() {
    mut app := &App{}
    mut context := gg.new_context(
        width: width
        height: height
        window_title: "Color Wheel"
        frame_fn: frame
        user_data: app
        bg_color: gx.black
    )
    context.run()
}

fn frame(mut app App) {
    mut ctx := gg.Context{}
    ctx.begin()
    for y in 0 .. height {
        dy := app.cy - y
        for x in 0 .. width {
            dx := x - app.cx
            dist := math.sqrt(f64(dx * dx + dy * dy))
            if dist < f64(app.r) {
                mut angle := math.atan2(f64(dy), f64(dx)) * 180 / math.pi
                if angle < 0 { angle += 360 }
                s := f32(dist / f64(app.r))
                v := f32(1.0)
                col := hsv_to_rgb(f32(angle), s, v)
				// `draw_pixel` not best for large width and height
                ctx.draw_pixel(f32(x), f32(y), col, size: 1)
            }
        }
    }
    ctx.end()
}
