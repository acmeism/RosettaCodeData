import gg
import gx
import math

struct App {
	mut:
    iter          int
    turns         []int
    start_angle   f64
    side          f64
    angle         f64
    x1            int
    y1            int
    x2            int
    y2            int
    col           gx.Color
    ctx           gg.Context
}

fn get_sequence(iterations int) []int {
    mut turn_sequence := []int{}
    for _ in 0 .. iterations {
        mut copy := turn_sequence.clone()
        if copy.len > 1 { copy = copy.reverse() }
        turn_sequence << 1
        for i in copy {
            turn_sequence << -i
        }
    }
    return turn_sequence
}

fn (mut app App) dragon() {
    app.angle = app.start_angle
    app.x1 = 230
    app.y1 = 350
    app.x2 = app.x1 + int(math.cos(app.angle) * app.side)
    app.y2 = app.y1 + int(math.sin(app.angle) * app.side)
    app.ctx.draw_line(app.x1, app.y1, app.x2, app.y2, app.col)
    app.x1 = app.x2
    app.y1 = app.y2
    for turn in app.turns {
        app.angle += f64(turn) * math.pi / 2
        app.x2 = app.x1 + int(math.cos(app.angle) * app.side)
        app.y2 = app.y1 + int(math.sin(app.angle) * app.side)
        app.ctx.draw_line(app.x1, app.y1, app.x2, app.y2, app.col)
        app.x1 = app.x2
        app.y1 = app.y2
    }
}

fn (mut app App) init() {
    app.iter = 14
    app.turns = get_sequence(app.iter)
    app.start_angle = -f64(app.iter) * math.pi / 4
    app.side = 400.0 / math.pow(2, f64(app.iter) / 2)
    app.col = gx.blue
}

fn frame(mut app App) {
    app.ctx.begin()
    app.dragon()
    app.ctx.end()
}

fn main() {
    mut app := App{}
    mut context := gg.new_context(
        width: 800
        height: 600
        window_title: 'Dragon curve'
        user_data: &app
        frame_fn: frame
        bg_color: gx.white
    )
    app.init()
    context.run()
}
