import gg
import gx
import math

struct Polyspiral {
	mut:
    width  int
    height int
    inc    f64
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

fn (mut poly Polyspiral) draw_spiral(mut ctx gg.Context, length f64, angle_increment f64) {
    mut x1 := f64(poly.width) / 2
    mut y1 := f64(poly.height) / 2
    mut len := length
    mut angle := angle_increment
    for i in 0 .. 150 {
        hue := f32(i) / 150 * 360
        col := hsv_to_rgb(hue, 1, 1)
        x2 := x1 + math.cos(angle) * len
        y2 := y1 - math.sin(angle) * len
        ctx.draw_line(
            f32(x1), f32(y1),
            f32(x2), f32(y2),
            col
        )
        x1 = x2
        y1 = y2
        len += 3
        angle = math.mod(angle + angle_increment, math.pi * 2)
    }
}

fn (mut poly Polyspiral) update() {
    poly.inc = math.mod(poly.inc + 0.05, 360)
}

fn frame(mut poly Polyspiral) {
    mut ctx := gg.Context{}
    angle_radians := poly.inc * math.pi / 180
    ctx.begin()
    poly.update()
    poly.draw_spiral(mut ctx, 5, angle_radians)
    ctx.end()
}

fn main() {
    mut poly := Polyspiral{
        width: 640
        height: 640
        inc: 0
    }
    mut context := gg.new_context(
        width: poly.width
        height: poly.height
        window_title: 'Polyspiral'
        frame_fn: frame
        user_data: &poly
    )
    context.run()
}
