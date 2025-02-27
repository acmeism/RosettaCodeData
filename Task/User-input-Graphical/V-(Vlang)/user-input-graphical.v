import ui

@[heap]
struct App {
	mut:
	win &ui.Window = unsafe {nil}
	instr string = "Enter some text, the number 75000, and press 'Validate'"
	txt string
	num string
}

fn main() {
	mut app := &App{}
//	widgets defined and placed first for clarity
	lbl_1 := ui.label(text: &app.instr, id: "lbl_1", justify: [0.5, 0.0]) // [x, y] for text placement
	lbl_2 := ui.label(text: "", id: "lbl_2", text_align: .center, justify: [0.5, 0.0])
	txt_1 := ui.textbox(placeholder: "String", text: &app.txt, id: "txt_1")
	txt_2 := ui.textbox(placeholder: "Number", text: &app.num, id: "txt_2")
	btn_1 := ui.button(width: 5, text: "Validate", on_click: app.btn_click)
//	column can be spread vertically and for visualization
	col := ui.column(
		alignment: .center // button's center, relative to UI
		spacing: 5 // button's distance from other widgets
		widths: [ui.stretch, 150] // button's width relative to UI				
		margin: ui.Margin{0, 5, 0, 5} // widgets relative to UI's edges, {y, right, x, left}
		children: [
			ui.column(
				alignment: .center
                spacing: 5 // distance between widgets in same column
                children: [
			        lbl_1
					lbl_2
			        txt_1
			        txt_2
                ]
            ),
			btn_1 // button in and controlled from separate column
		]
	)
	app.win = ui.window(height: 150, width: 450, title: "Input Info", mode: .resizable, children: [col])
	ui.run(app.win)
}

fn (mut app App) btn_click(btn &ui.Button) {
	mut lbl_2 := app.win.get_or_panic[ui.Label]("lbl_2") // id: "lbl_2" (used above)
	lbl_2.set_text("${app.txt} ${app.num}")
}
