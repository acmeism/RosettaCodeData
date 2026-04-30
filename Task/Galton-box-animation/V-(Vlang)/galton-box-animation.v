import rand

enum Cell {
	empty
	ball
	wall
	corner
	floor
	pin
}

const cell_chars = {
	Cell.empty: ` `
	Cell.ball: `o`
	Cell.wall: `|`
	Cell.corner: `+`
	Cell.floor: `-`
	Cell.pin: `.`
}

struct Ball {
	mut:
	x int
	y int
	box &GaltonBox
}

fn (mut b Ball) do_step() {
	if b.y <= 0 { return }
	cell := b.box.box[b.y - 1][b.x]
	match cell {
		.empty {
			b.box.box[b.y][b.x] = .empty
			b.y--
			b.box.box[b.y][b.x] = .ball
		}
		.pin {
			b.box.box[b.y][b.x] = .empty
			b.y--
			left_empty := b.box.box[b.y][b.x - 1] == .empty
			right_empty := b.box.box[b.y][b.x + 1] == .empty
			if left_empty && right_empty {
                ran := rand.intn(2) or {0}
				if ran  == 0 { b.x-- }
				else { b.x++ }
				b.box.box[b.y][b.x] = .ball
				return
			}
			else if left_empty { b.x-- }
			else { b.x++ }
			b.box.box[b.y][b.x] = .ball
		}
		else {} // do nothing
	}
}

struct GaltonBox {
	box_w       int = 41
	box_h       int = 37
	pins_base_w int = 19
	n_max_balls int = 55
	center_h    int
	mut:
	box [][]Cell
	rand_seed int
}

fn new_galton_box() &GaltonBox {
	mut gb := &GaltonBox{
		center_h: 19 + (41 - 19 * 2 + 1) / 2 - 1
	}
	gb.box = [][]Cell{len: gb.box_h, init: []Cell{len: gb.box_w, init: .empty}}
	return gb
}

fn (mut gb GaltonBox) initialize_box() {
	gb.box[0][0] = .corner
	gb.box[0][gb.box_w - 1] = .corner
	for i := 1; i < gb.box_w - 1; i++ {
		gb.box[0][i] = .floor
	}
	for i := 0; i < gb.box_w; i++ {
		gb.box[gb.box_h - 1][i] = gb.box[0][i]
	}
	for r := 1; r < gb.box_h - 1; r++ {
		gb.box[r][0] = .wall
		gb.box[r][gb.box_w - 1] = .wall
	}
	for n_pins := 1; n_pins <= gb.pins_base_w; n_pins++ {
		for pin := 0; pin < n_pins; pin++ {
			gb.box[gb.box_h - 2 - n_pins][gb.center_h + 1 - n_pins + pin * 2] = .pin
		}
	}
}

fn (gb &GaltonBox) draw_box() {
	for row in gb.box.reverse() {
		for cell in row {
			print(cell_chars[cell])
		}
		println("")
	}
}

fn main() {
	mut balls := []Ball{}
	mut gb := new_galton_box()
	gb.initialize_box()
	for i in 0 .. gb.n_max_balls + gb.box_h {
		println("\nStep $i:")
		if i < gb.n_max_balls {
			balls << Ball{
				x: gb.center_h
				y: gb.box_h - 2
				box: gb
			}
			gb.box[gb.box_h - 2][gb.center_h] = .ball
		}
		gb.draw_box()
		for mut b in balls {
			b.do_step()
		}
	}
}
