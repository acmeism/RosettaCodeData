import gg
import gx
import math

struct Element {
    x int
    y int
}

struct Pendulum {
    mut:
    dt             f64 = 0.1
    angle          f64 = math.pi / 2
    angle_velocity f64
    length         f64
    anchor         Element
    fore           gx.Color = gx.black
    width          int
    height         int
}

fn new_pendulum(length f64) Pendulum {
    w := int(2 * length + 50)
    h := int(length / 2 * 3)
    anchor := Element{
        x: w / 2
        y: h / 4
    }
    return Pendulum{
        length: length
        width:  w
        height: h
        anchor: anchor
    }
}

fn (mut p Pendulum) draw(mut ctx gg.Context) {
    ctx.begin()
    // calculate ball position
    ball_x := int(p.anchor.x + math.sin(p.angle) * p.length)
    ball_y := int(p.anchor.y + math.cos(p.angle) * p.length)
    // line from anchor to ball
    ctx.draw_line(p.anchor.x, p.anchor.y, ball_x, ball_y, p.fore)
    // anchor circles
    ctx.draw_ellipse_filled(p.anchor.x - 3, p.anchor.y - 4, 7, 7, gx.light_gray)
    ctx.draw_ellipse_empty(p.anchor.x - 3, p.anchor.y - 4, 7, 7, p.fore)
    // ball circles
    ctx.draw_ellipse_filled(ball_x - 7, ball_y - 7, 14, 14, gx.yellow)
    ctx.draw_ellipse_empty(ball_x - 7, ball_y - 7, 14, 14, p.fore)
    ctx.end()
}

// pendulum motion
fn (mut p Pendulum) update() {
    gravity := 9.81
    p.angle_velocity = p.angle_velocity - gravity / p.length * math.sin(p.angle) * p.dt
    p.angle = p.angle + p.angle_velocity * p.dt
}

fn frame(mut pendulum Pendulum) {
	mut ctx := gg.Context{}
    pendulum.update()
    pendulum.draw(mut ctx)
}

fn main() {
    mut pendulum := new_pendulum(200)
    mut context := gg.new_context(
        width: pendulum.width
        height: pendulum.height
        window_title: "Pendulum"
        frame_fn: frame
        user_data: &pendulum
        bg_color: gx.white
    )
    context.run()
}
