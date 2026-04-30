const grid_size = 9

fn is_number_in_row(board [][]int, number int, row int) bool {
	for cell in board[row] {
		if cell == number { return true }
	}
	return false
}

fn is_number_in_column(board [][]int, number int, column int) bool {
	for row in board {
		if row[column] == number { return true }
	}
	return false
}

fn is_number_in_box(board [][]int, number int, row int, column int) bool {
	local_box_row := row - row % 3
	local_box_column := column - column % 3

	for i := local_box_row; i < local_box_row + 3; i++ {
		for j := local_box_column; j < local_box_column + 3; j++ {
			if board[i][j] == number { return true }
		}
	}
	return false
}

fn is_valid_placement(board [][]int, number int, row int, column int) bool {
	return !is_number_in_row(board, number, row) &&
		!is_number_in_column(board, number, column) &&
		!is_number_in_box(board, number, row, column)
}

fn solve_board(mut board [][]int) bool {
	for i, row in board {
		for j, cell in row {
			if cell == 0 {
				for n := 1; n <= grid_size; n++ {
					if is_valid_placement(board, n, i, j) {
						board[i][j] = n
						if solve_board(mut board) { return true }
						else { board[i][j] = 0 }
					}
				}
				return false
			}
		}
	}
	return true
}

fn print_board(board [][]int) {
	for i, row in board {
		for j, cell in row {
			print(cell.str())
			if j == 2 || j == 5 { print("|") }
		}
		println("")
		if i == 2 || i == 5 { println("-----------") }
	}
	println("")
}

fn main() {
	mut board := [
		[7, 0, 2, 0, 5, 0, 6, 0, 0],
		[0, 0, 0, 0, 0, 3, 0, 0, 0],
		[1, 0, 0, 0, 0, 9, 5, 0, 0],
		[8, 0, 0, 0, 0, 0, 0, 9, 0],
		[0, 4, 3, 0, 0, 0, 7, 5, 0],
		[0, 9, 0, 0, 0, 0, 0, 0, 8],
		[0, 0, 9, 7, 0, 0, 0, 0, 5],
		[0, 0, 0, 2, 0, 0, 0, 0, 0],
		[0, 0, 7, 0, 4, 0, 2, 0, 3],
	]

	print_board(board)
	if solve_board(mut board) { print_board(board) }
}
