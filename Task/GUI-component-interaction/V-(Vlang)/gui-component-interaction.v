import ui
import gx
import rand

const (
	win_width  = 400
	win_height = 40
)

[heap]
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
//					is_numeric: true // Can enforce only number input
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
					text: "random"
					bg_color: gx.light_gray
					radius: 5
					border_color: gx.gray
					on_click: app.btn_click_ran
				),
			]
		)
	)
	ui.run(app.window)
}

fn (mut app App) btn_click_inc(mut btn ui.Button) {
	for value in app.counter {
		if value.is_digit() == false {
			ui.message_box("Only numbers allowed!")
			return
		}
	}
	if app.counter.int() < 0 || app.counter.int() > 100 {
		ui.message_box("Only numbers between 0 to 100 accepted!\nResetting to 1.")
		app.counter = "0"
	}
	app.counter = (app.counter.int() + 1).str()
}

fn (mut app App) btn_click_ran(mut btn ui.Button) {
	ui.message_box("Will jump to random number between 1 and 100.")
	app.counter = rand.int_in_range(1, 100) or {0}.str()	
}
