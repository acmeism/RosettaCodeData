import rand
import os

struct Board {
	mut:
	bay [3][3]int
	best_i int
	best_j int
}

fn main() {
	mut brd := Board{}
	mut user := false
	mut yn :=""
	for {
		user = !user
		print(game(mut brd, user))
		for (yn != "y" ) && (yn != "n") {
			yn = os.input("Play again y/n: ").str().to_lower()
		}
		if yn != "y" {exit(0)} else {yn =""}
		println("")
	}
}

fn game(mut brd Board, user bool) string {
	mut ubl := user
	mut move, mut my_move, mut ir, mut jir, mut win := 0, 0, 0, 0, 0
	for kal in 0..3 {
		for lal in 0..3 {
			if brd.bay[kal][lal] != 0 {brd.bay[kal][lal] = 0}
		}
	}
	print("Board postions are numbered so:\n1 2 3\n4 5 6\n7 8 9\n")
	print("You have O, I have X.\n\n")	
	for kal in 1..9 {
		if ubl {
			for move !in [1,2,3,4,5,6,7,8,9] {
 				move = os.input("your move: ").int()
			}
			move--
			ir = move / 3
			jir = move % 3		
			if brd.bay[ir][jir] != 0 {continue}
			brd.bay[ir][jir] = 1
			move = 0
		}
		if !ubl {
			if kal == 1 {
				brd.best_i = (rand.int_in_range(1, 9) or {exit(1)}) % 3
				brd.best_j = (rand.int_in_range(1, 9) or {exit(1)}) % 3
			}
			else {test_move(mut brd, -1, 0)}
			brd.bay[brd.best_i][brd.best_j] = -1
			my_move = brd.best_i * 3 + brd.best_j + 1
			println("My move: $my_move")
		}
		show_board(mut brd)
		win = check_winner(mut brd)
		println("win res: $win")
		if win != 0 {
			if win == 1 {return "You win" + ".\n\n"}
			else {return "I win" + ".\n\n"}
		}
		ubl = !ubl
	}
	return "A draw.\n\n"
}

fn check_winner(mut brd Board) int {
	for ial in 0..3 {
		if brd.bay[ial][0] != 0 && brd.bay[ial][1] == brd.bay[ial][0] && brd.bay[ial][2] == brd.bay[ial][0] {
				return brd.bay[ial][0]
		}
		if brd.bay[0][ial] != 0 && brd.bay[1][ial] == brd.bay[0][ial] && brd.bay[2][ial] == brd.bay[0][ial] {
				return brd.bay[0][ial]
		}
	}
	if brd.bay[1][1] == 0 {return 0}
	if brd.bay[1][1] == brd.bay[0][0] && brd.bay[2][2] == brd.bay[0][0] {return brd.bay[0][0]}
	if brd.bay[1][1] == brd.bay[2][0] && brd.bay[0][2] == brd.bay[1][1] {return brd.bay[1][1]}
	return 0
}

fn show_board(mut brd Board) {
	mut t := "X O"
	for ial in 0..3 {
		for jal in 0..3 {
			print("${t[brd.bay[ial][jal] + 1].ascii_str()} ")
		}
		println("")
	}
	println("-----")
}

fn test_move(mut brd Board, value int, depth int) int {
	mut best := -1
	mut changed := 0
	mut score := check_winner(mut brd)
	if score != 0 {
		if score == value {return 1} else {return -1}
	}
	for ial in 0..3 {
		for jal in 0..3 {
			if brd.bay[ial][jal] != 0 {continue}
			brd.bay[ial][jal] = value
			changed = value
			score = -test_move(mut brd, -value, depth + 1)
			brd.bay[ial][jal] = 0
			if score <= best {continue}
			if depth == 0 {
				brd.best_i = ial
				brd.best_j = jal
			}
			best = score
		}
	}
	if changed != 0 {return best}
	return 0
}
