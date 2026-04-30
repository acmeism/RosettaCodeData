import gg
import gx
import math

struct App {
    mut:
    n f64
    a int
}

fn (mut app App) super_ellipse_points() []f32 {
    hw := 300.0
    hh := 200.0
    mut points := []f32{}
    mut y := []f64{len: app.a + 1}
    for x in 0 .. app.a + 1 {
        aa := math.pow(f64(app.a), app.n)
        xx := math.pow(f64(x), app.n)
        y[x] = math.pow(aa - xx, 1.0 / app.n)
    }
    for x := app.a; x >= 0; x-- {
        points << f32(hw + f64(x))
        points << f32(hh - y[x])
    }
    for x in 0 .. app.a + 1 {
        points << f32(hw + f64(x))
        points << f32(hh + y[x])
    }
    for x := app.a; x >= 0; x-- {
        points << f32(hw - f64(x))
        points << f32(hh + y[x])
    }
    for x in 0 .. app.a + 1 {
        points << f32(hw - f64(x))
        points << f32(hh - y[x])
    }
    return points
}

fn frame(mut app App) {
    app.n = 2.5
    app.a = 200
    mut ctx := gg.Context{}
    ctx.begin()
    points := app.super_ellipse_points()
    ctx.draw_convex_poly(points, gx.white)
    ctx.end()
}

fn main() {
    mut context := gg.new_context(
        bg_color: gx.black
        width: 600
        height: 400
        window_title: "SuperEllipse"
        frame_fn: frame
        user_data: &App{}
    )
    context.run()
}
