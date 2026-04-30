struct Board {
	cur string
	sol string
	xir   int
	yir   int
}

struct Direction {
	dxir int
	dyir int
}

struct Queue {
	mut:
	data []Board
}

fn (mut que Queue) push(brd Board) {
	que.data << brd
}

fn (mut que Queue) pop() ?Board {
	if que.data.len == 0 { return none }
	item := que.data[0]
	que.data = que.data[1..]
	return item
}

fn (que Queue) is_empty() bool {
	return que.data.len == 0
}

struct Sokoban {
	n_cols     int
	dest_board string
	curr_board string
	player_x   int
	player_y   int
}

fn new_sokoban(board []string) Sokoban {
	n_cols := board[0].len
	mut dest_buf := []u8{}
	mut curr_buf := []u8{}
	mut player_x := 0
	mut player_y := 0
	for ral in 0 .. board.len {
		for cal in 0 .. n_cols {
			ch := board[ral][cal]
			dest_buf << if ch != `$` && ch != `@` { ch } else { ` ` }
			curr_buf << if ch != `.` { ch } else { ` ` }
			if ch == `@` {
				player_x = cal
				player_y = ral
			}
		}
	}

	return Sokoban{
		n_cols: n_cols
		dest_board: dest_buf.bytestr()
		curr_board: curr_buf.bytestr()
		player_x: player_x
		player_y: player_y
	}
}

fn (skn Sokoban) move(xir int, yir int, dxir int, dyir int, trial_board string) string {
	new_pos := (yir + dyir) * skn.n_cols + xir + dxir
	if trial_board[new_pos] != ` ` { return "" }
	mut trial := trial_board.bytes()
	trial[yir * skn.n_cols + xir] = ` `
	trial[new_pos] = `@`
	return trial.bytestr()
}

fn (skn Sokoban) push(xir int, yir int, dxir int, dyir int, trial_board string) string {
	new_box_pos := (yir + 2 * dyir) * skn.n_cols + xir + 2 * dxir
	if trial_board[new_box_pos] != ` ` { return "" }
	mut trial := trial_board.bytes()
	trial[yir * skn.n_cols + xir] = ` `
	trial[(yir + dyir) * skn.n_cols + xir + dxir] = `@`
	trial[new_box_pos] = `$`
	return trial.bytestr()
}

fn (skn Sokoban) is_solved(trial_board string) bool {
	for ial in 0 .. trial_board.len {
		if (skn.dest_board[ial] == `.`) != (trial_board[ial] == `$`) { return false }
	}
	return true
}

fn (skn Sokoban) solve() string {
	dir_labels := [`u`, `r`, `d`, `l`]
	dir_labels_caps := [`U`, `R`, `D`, `L`]
	dirs := [
		Direction{dxir: 0, dyir: -1},
		Direction{dxir: 1, dyir: 0},
		Direction{dxir: 0, dyir: 1},
		Direction{dxir: -1, dyir: 0},
	]
	mut trial := ""
	mut open := Queue{}
	mut history := map[string]bool{}
	history[skn.curr_board] = true
	open.push(Board{
		cur: skn.curr_board
		sol: ""
		xir: skn.player_x
		yir: skn.player_y
	})
	for !open.is_empty() {
		cur_board := open.pop() or { break }
		cur := cur_board.cur
		sol := cur_board.sol
		xir := cur_board.xir
		yir := cur_board.yir

		for i in 0 .. dirs.len {
			dxir := dirs[i].dxir
			dyir := dirs[i].dyir
			trial = cur
			if trial[(yir + dyir) * skn.n_cols + xir + dxir] == `$` {
				trial = skn.push(xir, yir, dxir, dyir, trial)
				if trial != "" && !history[trial] {
					new_sol := sol + dir_labels_caps[i].str()
					if skn.is_solved(trial) { return new_sol }
					open.push(Board{
						cur: trial
						sol: new_sol
						xir: xir + dxir
						yir: yir + dyir
					})
					history[trial] = true
				}
			}
			else
			{
				trial = skn.move(xir, yir, dxir, dyir, trial)
				if trial != "" && !history[trial] {
					new_sol := sol + dir_labels[i].str()
					open.push(Board{
						cur: trial
						sol: new_sol
						xir: xir + dxir
						yir: yir + dyir
					})
					history[trial] = true
				}
			}
		}
	}
	return "No solution"
}

fn main() {
	level := [
		"#######",
		"#     #",
		"#     #",
		"#. #  #",
		"#. $$ #",
		"#.$$  #",
		"#.#  @#",
		"#######",
	]

	for line in level {
		println(line)
	}
	println("")
	sokoban := new_sokoban(level)
	println(sokoban.solve())
}
