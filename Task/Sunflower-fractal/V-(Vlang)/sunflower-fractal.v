import gg
import gx
import math

fn main() {
    mut context := gg.new_context(
        bg_color: gx.rgb(255, 255, 255)
        width: 400
        height: 400
        frame_fn: frame
    )
    context.run()
}

fn frame(mut ctx gg.Context) {
    ctx.begin()
    c := (math.sqrt(5) + 1) / 2
    num_of_seeds := 3000
    for i := 0; i <= num_of_seeds; i++ {
        mut fi := f64(i)
        n := f64(num_of_seeds)
        r := math.pow(fi, c) / n
        angle := 2 * math.pi * c * fi
        x := r*math.sin(angle) + 200
        y := r*math.cos(angle) + 200
        fi /= n / 5
        ctx.draw_circle_filled(f32(x), f32(y), f32(fi), gx.black)
    }
    ctx.end()
}
