import ui
import gx

[heap]
struct App {
	mut:
	window &ui.Window = unsafe {nil}
	counter string = "No clicks yet" // will contain number count
}

fn main() {
	mut app := &App{}
	app.window = ui.window(
		width: 200
		height: 40
		title: "Counter"
		mode: .resizable
		layout: ui.row(
			spacing: 5
			margin_: 10
			widths: ui.stretch
			heights: ui.stretch
			children: [
				ui.label(
					id: "num"
					text: &app.counter //refer to struct App
				),
				ui.button(
					text: "Click me"
					bg_color: gx.light_gray
					radius: 5
					border_color: gx.gray
					on_click: app.btn_click //refer to function below
				),
			]
		)
	)
	ui.run(app.window)
}

fn (mut app App) btn_click(btn &ui.Button) {
	mut lbl := app.window.get_or_panic[ui.Label]("num") //"num" is id of label
	app.counter = (app.counter.int() + 1).str() //change to string for label display
	lbl.set_text(app.counter)
}
