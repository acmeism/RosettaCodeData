import gg
import gx

fn main() {
    mut app := gg.new_context(
		bg_color: gx.white
		resizable: true
		create_window: true
        width: 600
        height: 600
        frame_fn: frame
		window_title: "Empty Window"
    )
    app.run()
}

fn frame(mut ctx gg.Context) {
    ctx.begin()
    ctx.end()
}
