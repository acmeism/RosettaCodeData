import gg
import gx

fn main() {
    mut context := gg.new_context(
        width: 320
        height: 240
        frame_fn: frame
    )
    context.run()
}

fn frame(mut ctx gg.Context) {
    ctx.begin()
    ctx.draw_pixel(100, 100, gx.red)
    ctx.end()
}
