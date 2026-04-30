import gg
import gx

struct Point {
	x f32
	y f32
}

struct Hilbert {
	width int
	mut:
	points []Point
}

fn (mut h Hilbert) hilbert(x int, y int, plg int, i1 int, i2 int) {
	mut lg := plg
	if lg == 1 {
		px := f32(h.width - x) * 10
		py := f32(h.width - y) * 10
		h.points << Point{px, py}
		return
	}
	lg = lg >> 1
	h.hilbert(x + i1 * lg, y + i1 * lg, lg, i1, 1 - i2)
	h.hilbert(x + i2 * lg, y + (1 - i2) * lg, lg, i1, i2)
	h.hilbert(x + (1 - i1) * lg, y + (1 - i1) * lg, lg, i1, i2)
	h.hilbert(x + (1 - i2) * lg, y + i2 * lg, lg, 1 - i1, i2)
}

fn frame(mut ctx gg.Context) {
	color := gx.rgb(144, 238, 144)	
	mut hilbert_obj := Hilbert{width: 64}
	hilbert_obj.hilbert(0, 0, hilbert_obj.width, 0, 0)
	ctx.begin()
	// draw lines between consecutive points
	for i := 0; i < hilbert_obj.points.len - 1; i++ {
		p1 := hilbert_obj.points[i]
		p2 := hilbert_obj.points[i + 1]
		ctx.draw_line(p1.x, p1.y, p2.x, p2.y, color)
	}
	ctx.end()
}

fn main() {
	mut context := gg.new_context(
		width: 640
		height: 640
		window_title: "Hilbert Curve"
		bg_color: gx.black
		frame_fn: frame
	)
	context.run()
}
