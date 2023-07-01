import ui
import gg
import gx

[heap]
struct App {
	mut:
	window &ui.Window = unsafe {nil}
}

fn main() {
	mut app := &App{}
	app.window = ui.window(
		width: gg.screen_size().width
		height: gg.screen_size().height
		bg_color: gx.white
		title: "Maximum Window"
		mode: .resizable
		layout: ui.row(
			spacing: 5
			margin_: 10
			widths: ui.stretch
			heights: ui.stretch
			children: [
				ui.label(
					id: "info"
					text: "Window dimensions: W ${gg.screen_size().width} x H ${gg.screen_size().height}"
				),
			]
		)
	)
	ui.run(app.window)
}
