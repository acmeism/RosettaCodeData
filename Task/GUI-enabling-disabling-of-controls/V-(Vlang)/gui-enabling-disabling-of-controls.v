import ui
import gx

const (
	win_width  = 400
	win_height = 40
)

@[heap]
struct App {
	mut:
	window &ui.Window = unsafe {nil}
	counter string = "0"
}

fn main() {
	mut app := &App{}
	app.window = ui.window(
		width: win_width
		height: win_height
		title: "Counter"
		mode: .resizable
		layout: ui.row(
			spacing: 5
			margin_: 10
			widths: ui.stretch
			heights: ui.stretch
			children: [
				ui.textbox(
					max_len: 20
					read_only: false
					is_numeric: true
					text: &app.counter
				),
				ui.button(
					text: "increment"
					bg_color: gx.light_gray
					radius: 5
					border_color: gx.gray
					on_click: app.btn_click_inc
				),
				ui.button(
					text: "decrement"
					bg_color: gx.light_gray
					radius: 5
					border_color: gx.gray
					on_click: app.btn_click_dec
				),
			]
		)
	)
	ui.run(app.window)
}

fn (mut app App) btn_click_inc(mut btn ui.Button) {
	if app.counter.int() > 10 {
		btn.disabled = true
		return
	}
	app.counter = (app.counter.int() + 1).str()
}

fn (mut app App) btn_click_dec(mut btn ui.Button) {
	if app.counter.int() < 0 {
		btn.disabled = true
		return
	}
	app.counter = (app.counter.int() - 1).str()	
}
