import gg
import gx

const (
	win_width  = 600
	win_height = 600
)

struct App {
	mut:
	gg    &gg.Context = unsafe {nil}
}

fn main() {
	mut app := &App{
		gg: 0
	}
	app.gg = gg.new_context(
		bg_color: gx.white
		width: win_width
		height: win_height
		create_window: true
		window_title: 'Circle'
		frame_fn: frame
		user_data: app
	)
	app.gg.run()
}

fn frame(app &App) {
	app.gg.begin()
	app.draw()
	app.gg.end()
}

fn (app &App) draw() {
	app.gg.draw_circle_filled(300, 300, 150, gx.red)
}
