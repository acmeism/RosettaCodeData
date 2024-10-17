import ui

@[heap]
struct App {
	mut:
	win &ui.Window = unsafe {nil}
	txt_1 &ui.TextBox = unsafe {nil}
	txt_2 &ui.TextBox = unsafe {nil}
	lbl_1 &ui.Label = unsafe {nil}
	lbl_2 &ui.Label = unsafe {nil}
	btn_1 &ui.Button = unsafe {nil}
	instr string = "Enter some text, the number 75000, and press 'Validate'"
	txt string
	num string
}

fn main() {
	mut app := &App{}
//	widgets defined and placed here for clarity
	app.lbl_1 = ui.label(text: &app.instr, id: "lbl_1", justify: [0.5, 0.0]) // [x, y] for text placement
	app.lbl_2 = ui.label(text: "", id: "lbl_2", text_align: .center, justify: [0.5, 0.0])
	app.txt_1 = ui.textbox(placeholder: "String", text: &app.txt, id: "txt_1")
	app.txt_2 = ui.textbox(placeholder: "Number", text: &app.num, id: "txt_2")
	app.btn_1 = ui.button(width: 5, text: "Validate", on_click: app.btn_click)

	app.win = ui.window(
		height: 150
		width: 450
		title: "Input Info"
		mode: .resizable
		children: [
			ui.column(
				alignment: .center // button's center, relative to UI
				spacing: 5 // button's distance from other widgets
				widths: [ui.stretch, 150] // button's width relative to UI				
				margin: ui.Margin{0, 5, 0, 5} // widgets relative to UI's edges, {y, right, x, left}
				children: [
			        ui.column(
						alignment: .center
                        spacing: 5 // distance between widgets in same column
                        children: [
					        app.lbl_1
							app.lbl_2
					        app.txt_1
					        app.txt_2
                        ]
                    ),
					// button in and controlled from separate column
					app.btn_1	
				]
			),
		]
	)
	ui.run(app.win)
}

fn (mut app App) btn_click(btn &ui.Button) {
	app.lbl_2.set_text("${app.txt} ${app.num}")
}
