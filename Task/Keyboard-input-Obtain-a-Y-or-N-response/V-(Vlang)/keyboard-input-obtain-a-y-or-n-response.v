import term.ui as tui

struct App {
mut:
	tui &tui.Context = 0
}

fn event(e &tui.Event, x voidptr) {
	mut app := &App(x)
	app.tui.clear()
	app.tui.set_cursor_position(0, 0)
	app.tui.write('V term.input event viewer (type `y`, `Y`, `n`, or `N` to exit)\n\n')
	if e.typ == .key_down {
        mut cap := ''
        if !e.modifiers.is_empty() && e.modifiers.has(.shift) {
            cap = 'capital'
        }
        match e.code {
            .y {
		        app.tui.write('You typed $cap y')
            }
            .n {
                app.tui.write('You typed $cap n')
            }
            else {
                app.tui.write("You didn't type n or y")
            }
        }
	}
	app.tui.flush()

    if e.typ == .key_down && (e.code == .y || e.code==.n) {
		exit(0)
	}
}

fn main() {
	mut app := &App{}
	app.tui = tui.init(
		user_data: app
		event_fn: event
		window_title: 'V term.ui event viewer'
		hide_cursor: true
		capture_events: true
		frame_rate: 60
		use_alternate_buffer: false
	)
	println('V term.input event viewer (type `y`, `Y`, `n`, or `N` to exit)\n\n')
	app.tui.run()?
}
