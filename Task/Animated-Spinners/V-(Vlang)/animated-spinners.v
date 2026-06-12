import gg
import gx
import math

struct Vec2 {
	x f32
	y f32
}

struct Spinner {
	mut:
	pos    Vec2
	colour gx.Color
}

struct App {
	mut:
	angle    f64 = 0.0
	spinners []Spinner
	half     f32 = f32(w_size / 2)
}

const w_size   = 800
const s_radius = 100.0
const s_offset = s_radius * 2
const speed    = 250.0 // degrees per second


fn new_spinner(x f32, y f32, colour gx.Color) Spinner {
	return Spinner{
		pos: Vec2{ x, y }
		colour: colour
	}
}

fn end_pos(pos Vec2, angle f64) Vec2 {
	converted_angle := angle * (math.pi / 180.0)
	return Vec2{
		x: pos.x + f32(s_radius * math.cos(converted_angle))
		y: pos.y + f32(s_radius * math.sin(converted_angle))
	}
}

fn frame(mut app App) {
	mut ctx := gg.Context{}
	if app.spinners.len == 0 {
		app.spinners = [
			new_spinner(app.half, app.half, gx.green),                            // center
			new_spinner(app.half - s_offset, app.half + s_offset, gx.white),      // top-left-ish
			new_spinner(app.half - s_offset, app.half - s_offset, gx.red),        // bottom-left-ish
			new_spinner(app.half + s_offset, app.half + s_offset, gx.yellow),     // top-right-ish
			new_spinner(app.half + s_offset, app.half - s_offset, gx.orange),     // bottom-right-ish
		]
	}
	ctx.begin()
	ctx.draw_circle_filled(app.half, app.half, app.half, gx.black)
	// draw each spinner"s rotating "hand"
	for s in app.spinners {
		end := end_pos(s.pos, app.angle)
		cfg := gg.PenConfig{
			color: s.colour
			line_type: .solid
			thickness: 2.0
		}
		ctx.draw_line_with_config(s.pos.x, s.pos.y, end.x, end.y, cfg)
	}
	ctx.end()
	// degrees per frame assuming 60 FPS
	app.angle = math.mod(app.angle + speed / 60.0, 360)
}

fn main() {
	mut content := gg.new_context(
		width: w_size
		height: w_size
		window_title: "Spinner"
		frame_fn: frame
		user_data: &App{}
		bg_color: gx.light_gray
	)
	content.run()
}
