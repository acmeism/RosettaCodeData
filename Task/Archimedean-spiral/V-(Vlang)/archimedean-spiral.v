import gg
import gx
import math

struct Size {
	mut:
    width  int = 400
    height int = 400
}

fn (s &Size) draw_spiral(ctx &gg.Context, col gx.Color) {
    mut theta := 0.0
    max_theta := 52 * math.pi
    for theta < max_theta {
        // x, y based on Archimedean spiral formula
        x := int(((math.cos(theta / math.pi) * theta) + f64(s.width) / 2))
        y := int(((math.sin(theta / math.pi) * theta) + f64(s.height) / 2))
        // draw
        ctx.draw_rect_filled(f32(x), f32(y), 1, 1, col)
        theta += 0.025
    }
}

fn frame(mut s Size) {
    mut ctx := gg.Context{}
    ctx.begin()
    s.draw_spiral(ctx, gx.red)
    ctx.end()
}

fn main() {
    mut s := Size{}
    mut context := gg.new_context(
        width:        s.width
        height:       s.height
        window_title: "Archimedean Spiral"
        frame_fn:     frame
        user_data:    &s
    )
    context.run()
}
