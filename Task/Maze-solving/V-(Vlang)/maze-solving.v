import rand
import os

struct Direction {
	bit int
	dx  int
	dy  int
}

type Maze = [][]int

struct MazeGenerator {
	x          int
	y          int
	mut:
	maze       Maze
	directions []Direction
	opposites  map[int]Direction
	solution   [][]bool
}

fn new_maze_generator(x int, y int) MazeGenerator {
	mut maze := [][]int{len: x}
	for i in 0 .. x {
		maze[i] = []int{len: y, init: 0}
	}
	mut solution := [][]bool{len: x}
	for i in 0 .. x {
		solution[i] = []bool{len: y, init: false}
	}
	directions := [
		Direction{bit: 1, dx: 0, dy: -1}, // N
		Direction{bit: 2, dx: 0, dy: 1},  // S
		Direction{bit: 4, dx: 1, dy: 0},  // E
		Direction{bit: 8, dx: -1, dy: 0}, // W
	]
	opposites := {
		1: directions[1] // N.opposite = S
		2: directions[0] // S.opposite = N
		4: directions[3] // E.opposite = W
		8: directions[2] // W.opposite = E
	}
	return MazeGenerator{
		x: x
		y: y
		maze: maze
		directions: directions
		opposites: opposites
		solution: solution
	}
}

fn (mg MazeGenerator) between(v int, upper int) bool {
	return v >= 0 && v < upper
}

fn (mg MazeGenerator) directions_shuffled() ![]Direction {
	mut dirs := mg.directions.clone()
	rand.shuffle(mut dirs) or { return error("Shuffle failed") }
	return dirs
}

fn (mut mg MazeGenerator) generate(cx int, cy int) {
	mut shuf := mg.directions_shuffled() or { panic("Shuffle in generate failed") }
	for dir in shuf {
		nx := cx + dir.dx
		ny := cy + dir.dy
		if mg.between(nx, mg.x) && mg.between(ny, mg.y) && mg.maze[nx][ny] == 0 {
			mg.maze[cx][cy] |= dir.bit
			opp := mg.opposites[dir.bit] or { panic("Opposite direction not found") }
			mg.maze[nx][ny] |= opp.bit
			mg.generate(nx, ny)
		}
	}
}

fn (mg MazeGenerator) to_char_maze() [][]rune {
	width := mg.x * 2 + 1
	height := mg.y * 2 + 1
	mut char_maze := [][]rune{len: height, init: []rune{len: width, init: `#`}}
	for y in 0 .. mg.y {
		for x in 0 .. mg.x {
			px := x * 2 + 1
			py := y * 2 + 1
			char_maze[py][px] = ` `
			cell := mg.maze[x][y]
			if (cell & 1) != 0 { char_maze[py - 1][px] = ` ` } // N
			if (cell & 2) != 0 { char_maze[py + 1][px] = ` ` } // S
			if (cell & 4) != 0 { char_maze[py][px + 1] = ` ` } // E
			if (cell & 8) != 0 { char_maze[py][px - 1] = ` ` } // W
		}
	}
	return char_maze
}

fn solve_maze_recursively(mut maze [][]rune, x int, y int, from_dir int) bool {
	mut ok := false
	for i := 0; i < 4 && !ok; i++ {
		if i != from_dir {
			match i {
				0 {
					if y > 0 && maze[y - 1][x] == ` ` {
						ok = solve_maze_recursively(mut maze, x, y - 2, 2)
					} // up
				}
				1 {
					if x + 1 < maze[0].len && maze[y][x + 1] == ` ` {
						ok = solve_maze_recursively(mut maze, x + 2, y, 3)
					} // right
				}
				2 {
					if y + 1 < maze.len && maze[y + 1][x] == ` ` {
						ok = solve_maze_recursively(mut maze, x, y + 2, 0)
					} // down
				}
				3 {
					if x > 0 && maze[y][x - 1] == ` ` {
						ok = solve_maze_recursively(mut maze, x - 2, y, 1)
					} // left
				}
				else {}
			}
		}
	}
	if x == 1 && y == 1 { ok = true }
	if ok {
		maze[y][x] = `*`
		match from_dir {
			0 { maze[y - 1][x] = `*` }
			1 { maze[y][x + 1] = `*` }
			2 { maze[y + 1][x] = `*` }
			3 { maze[y][x - 1] = `*` }
			else {}
		}
	}
	return ok
}

// solve maze then link to original grid
fn (mut mg MazeGenerator) solve() {
	mut char_maze := mg.to_char_maze()
	solve_maze_recursively(mut char_maze, char_maze[0].len - 2, char_maze.len - 2, -1)
	for y in 0 .. mg.y {
		for x in 0 .. mg.x {
			px := x * 2 + 1
			py := y * 2 + 1
			mg.solution[x][y] = char_maze[py][px] == `*`
		}
	}
}

// display maze solution on original grid copy
fn (mg MazeGenerator) display() {
	for i in 0 .. mg.y {
		for j in 0 .. mg.x {
			// North edge
			if (mg.maze[j][i] & 1) == 0 { print("+---") }
			else { print("+   ") }
		}
		println("+")

		for j in 0 .. mg.x {
			mut cell_char := " "
			if mg.solution[j][i] { cell_char = "*" }
			if (mg.maze[j][i] & 8) == 0 { print("| $cell_char ") }
			else { print("  $cell_char ") }
		}
		println("|")
	}
	for _ in 0 .. mg.x {
		print("+---")
	}
	println("+")
}

fn main() {
	args := os.args
	mut x := 8
	mut y := 8
	mut mg := new_maze_generator(x, y)
	if args.len >= 2 { x = args[1].int() }
	if args.len >= 3 { y = args[2].int() }
	mg.generate(0, 0)
	println("Generated Maze:")
	mg.display()
	mg.solve()
	println("\nSolved Maze:")
	mg.display()
}
