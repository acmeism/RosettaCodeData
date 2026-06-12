import gg
import gx
import rand

const (
	win_width  = 640
	win_height = 480
	x = rand.int_in_range(1, win_width) or {exit(-1)}
	y = rand.int_in_range(1, win_height) or {exit(-1)}
)

fn main() {
    mut app := gg.new_context(
        width: win_width
        height: win_height
        frame_fn: frame
		window_title: 'Pixel 2'
    )
    app.run()
}

fn frame(mut ctx gg.Context) {
    ctx.begin()
    ctx.draw_pixel(x, y, gx.yellow)
    ctx.end()
}
