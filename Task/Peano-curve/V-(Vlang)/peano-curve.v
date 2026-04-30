import gg
import gx

struct Point {
	x f32
	y f32
}

struct Peano {
	width int
	mut:
	points []Point
}

fn (mut pea Peano) peano(x int, y int, plg int, i1 int, i2 int) {
	mut lg := plg
	if lg == 1 {
		px := f32(pea.width - x) * 10
		py := f32(pea.width - y) * 10
		pea.points << Point{px, py}
		return
	}
	lg /= 3
	pea.peano(x + 2 * i1 * lg, y + 2 * i1 * lg, lg, i1, i2)
	pea.peano(x + (i1 - i2 + 1) * lg, y + (i1 + i2) * lg, lg, i1, 1 - i2)
	pea.peano(x + lg, y + lg, lg, i1, 1 - i2)
	pea.peano(x + (i1 + i2) * lg, y + (i1 - i2 + 1) * lg, lg, 1 - i1, 1 - i2)
	pea.peano(x + 2 * i2 * lg, y + 2 * (1 - i2) * lg, lg, i1, i2)
	pea.peano(x + (1 + i2 - i1) * lg, y + (2 - i1 - i2) * lg, lg, i1, i2)
	pea.peano(x + 2 * (1 - i1) * lg, y + 2 * (1 - i1) * lg, lg, i1, i2)
	pea.peano(x + (2 - i1 - i2) * lg, y + (1 + i2 - i1) * lg, lg, 1 - i1, i2)
	pea.peano(x + 2 * (1 - i2) * lg, y + 2 * i2 * lg, lg, 1 - i1, i2)
}

fn frame(mut ctx gg.Context) {
	mut peano_obj := Peano{width: 81}
	peano_obj.peano(0, 0, peano_obj.width, 0, 0)
	ctx.begin()
	color := gx.rgb(255, 0, 255) // magenta
	for i := 0; i < peano_obj.points.len - 1; i++ {
		p1 := peano_obj.points[i]
		p2 := peano_obj.points[i + 1]
		ctx.draw_line(p1.x, p1.y, p2.x, p2.y, color)
	}
	ctx.end()
}

fn main() {
	mut context := gg.new_context(
		width: 820
		height: 820
		window_title: 'Peano Curve'
		bg_color: gx.white
		frame_fn: frame
	)
	context.run()
}
