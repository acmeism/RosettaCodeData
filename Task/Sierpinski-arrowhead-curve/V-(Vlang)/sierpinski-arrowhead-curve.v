import gg
import gx
import math

const width  = 770
const height = 770

struct App {
	mut:
	ggx    &gg.Context = unsafe { nil }
	cx     f64
	cy     f64
	h      f64
	iy     f64 = 1.0
	theta  int
	order  int = 6
	length f64
}

fn (mut app App) draw_line(length f64) {
	rads := math.radians(f64(app.theta))
	new_x := app.cx + length * math.cos(rads)
	new_y := app.cy + length * math.sin(rads)
	x1 := app.cx - f64(width) / 2 + app.h
	y1 := (f64(height) - app.cy) * app.iy + 2 * app.h
	x2 := new_x - f64(width) / 2 + app.h
	y2 := (f64(height) - new_y) * app.iy + 2 * app.h
	app.ggx.draw_line(int(x1), int(y1), int(x2), int(y2), gx.magenta)
	app.cx = new_x
	app.cy = new_y
}

fn (mut app App) turn(angle int) {
	app.theta = (app.theta + angle) % 360
}

fn (mut app App) curve(order int, length f64, angle int) {
	if order == 0 { app.draw_line(length) }
	else {
		app.curve(order - 1, length / 2, -angle)
		app.turn(angle)
		app.curve(order - 1, length / 2, angle)
		app.turn(angle)
		app.curve(order - 1, length / 2, -angle)
	}
}

fn (mut app App) arrowhead(order int, length f64) {
	if order & 1 == 0 { app.curve(order, length, 60) }
	else {
		app.turn(60)
		app.curve(order, length, -60)
	}
	app.draw_line(length)
}

fn frame(mut app App) {
	app.ggx.begin()
	app.cx = f64(width) / 2
	app.cy = f64(height)
	app.h = app.cx / 2
	app.iy = if app.order & 1 == 0 { -1.0 } else { 1.0 }
	app.theta = 0
	app.arrowhead(app.order, app.length)
	app.ggx.end()
}

fn main() {
	mut app := &App{length: f64(width) / 2}
	mut ggctx := gg.new_context(
		width: width
		height: height
		window_title: "Sierpinski Arrowhead Curve"
		user_data: app
		frame_fn: frame
		bg_color: gx.black
	)
	app.ggx = ggctx
	ggctx.run()
}
