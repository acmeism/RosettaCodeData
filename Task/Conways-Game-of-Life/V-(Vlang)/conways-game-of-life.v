import rand
import strings
import time

struct Field {
mut:
	s    [][]bool
	w int
	h int
}

fn new_field(w int, h int) Field {
	s := [][]bool{len: h, init: []bool{len: w}}
	return Field{s, w, h}
}

fn (mut f Field) set(x int, y int, b bool) {
	f.s[y][x] = b
}

fn (f Field) next(x int, y int) bool {
	mut on := 0
	for i := -1; i <= 1; i++ {
		for j := -1; j <= 1; j++ {
			if f.state(x+i, y+j) && !(j == 0 && i == 0) {
				on++
			}
		}
	}
	return on == 3 || (on == 2 && f.state(x, y))
}

fn (f Field) state(xx int, yy int) bool {
	mut x, mut y := xx, yy
	for y < 0 {
		y += f.h
	}
	for x < 0 {
		x += f.w
	}
	return f.s[y%f.h][x%f.w]
}

struct Life {
mut:
	w int
	h int
	a Field
	b Field
}

fn new_life(w int, h int) Life {
	mut a := new_field(w, h)
	for _ in 0..(w * h / 2) {
		a.set(rand.intn(w) or {0}, rand.intn(h) or {0}, true)
	}
	return Life{
		a: a,
		b: new_field(w, h),
		w: w
		h: h,
	}
}

fn (mut l Life) step() {
	for y in 0..l.h {
		for x in 0.. l.w {
			l.b.set(x, y, l.a.next(x, y))
		}
	}
	l.a, l.b = l.b, l.a
}

fn (l Life) str() string {
	mut buf := strings.new_builder(128)
	for y in 0..l.h {
		for x in 0..l.w {
			mut b := ' '
			if l.a.state(x, y) {
				b = '*'
			}
			buf.write_string(b)
		}
		buf.write_string('\n')
	}
	return buf.str()
}

fn main() {
	mut l := new_life(80, 15)
	for i := 0; i < 300; i++ {
		l.step()
		//println("------------------------------------------------")
		print('\x0c')
		println(l)
		time.sleep(time.second / 30)
	}
}
