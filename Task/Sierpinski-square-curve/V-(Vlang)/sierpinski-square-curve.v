import gg
import gx
import math

const pi = 3.141592653589793

struct Point {
	x f32
	y f32
}

struct Sierpinski {
	size        int
	length      f64
	order       int
	mut:
	instruction string
	points      []Point
}

fn (mut sie Sierpinski) generate_instructions() {
	mut s_instr := "F+XF+F+XF"
	for _ in 0 .. sie.order {
		mut t := ""
		for ch in s_instr {
			match ch {
				`X` { t += "XF-F+F-XF+F+XF-F+F-X" }
				else { t += ch.ascii_str() }
			}
		}
		s_instr = t
	}
	sie.instruction = s_instr
}

fn (mut sie Sierpinski) generate_points() {
	mut x := f64(sie.size - int(sie.length)) / 2.0
	mut y := sie.length
	mut angle := 0.0
	sie.points << Point{f32(x), f32(y)}
	for ch in sie.instruction {
		match ch {
			`F` {
				x += sie.length * math.cos(angle * pi / 180)
				y += sie.length * math.sin(angle * pi / 180)
				sie.points << Point{f32(x), f32(y)}
			}
			`+` {
				angle = math.mod(angle + 90, 360)
			}
			`-` {
				angle = math.mod(angle - 90 + 360, 360)
			}
			else {}
		}
	}
}

fn frame(mut ctx gg.Context) {
	mut sierpinski := Sierpinski{
		size: 635
		length: 5
		order: 5
	}
	sierpinski.generate_instructions()
	sierpinski.generate_points()
	ctx.begin()
	color := gx.black
	for i := 0; i < sierpinski.points.len - 1; i++ {
		p1 := sierpinski.points[i]
		p2 := sierpinski.points[i + 1]
		ctx.draw_line(p1.x, p1.y, p2.x, p2.y, color)
	}
	ctx.end()
}

fn main() {
	mut ctx := gg.new_context(
		width: 635
		height: 635
		window_title: "Sierpinski Square"
		bg_color: gx.white
		frame_fn: frame
	)
	ctx.run()
}
