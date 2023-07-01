import rand
import os

__global (
	b = [3][3]int{}
	best_i = 0
	best_j = 0
)

fn main() {
	mut user := false
	mut yn :=''
	for {
		user = !user
		print(game(user))
		for (yn != "y" ) && (yn != "n") {
			yn = os.input('Play again y/n: ').str().to_lower()
		}
		if yn != "y" {exit(0)} else {yn =''}
		println('')
	}
}

fn game(user bool) string {
	mut u := user
	mut move, mut my_move, mut i, mut j, mut win := 0, 0, 0, 0, 0
	for k in 0..3 {
		for l in 0..3 {
			if b[k][l] != 0 {b[k][l] = 0}
		}
	}
	print("Board postions are numbered so:\n1 2 3\n4 5 6\n7 8 9\n")
	print("You have O, I have X.\n\n")	
	for k in 1..9 {
		if u {
			for move !in [1,2,3,4,5,6,7,8,9] {
 				move = os.input('your move: ').int()
			}
			move--
			i = move / 3
			j = move % 3		
			if b[i][j] != 0 {continue}
			b[i][j] = 1
			move = 0
		}
		if !u {
			if k == 1 {
				best_i = (rand.int_in_range(1, 9) or {exit(1)}) % 3
				best_j = (rand.int_in_range(1, 9) or {exit(1)}) % 3
			}
			else {test_move(-1, 0)}
			b[best_i][best_j] = -1
			my_move = best_i * 3 + best_j + 1
			println("My move: $my_move")
		}
		show_board()
		win = check_winner()
		println("win res: $win")
		if win != 0 {
			if win == 1 {return "You win" + ".\n\n"}
			else {return "I win" + ".\n\n"}
		}
		u = !u
	}
	return "A draw.\n\n"
}

fn check_winner() int {
	for i in 0..3 {
		if b[i][0] != 0 && b[i][1] == b[i][0] && b[i][2] == b[i][0] {return b[i][0]}
		if b[0][i] != 0 && b[1][i] == b[0][i] && b[2][i] == b[0][i] {return b[0][i]}
	}
	if b[1][1] == 0 {return 0}
	if b[1][1] == b[0][0] && b[2][2] == b[0][0] {return b[0][0]}
	if b[1][1] == b[2][0] && b[0][2] == b[1][1] {return b[1][1]}
	return 0
}

fn show_board() {
	mut t := "X O"
	for i in 0..3 {
		for j in 0..3 {
			print("${t[b[i][j] + 1].ascii_str()} ")
		}
		println('')
	}
	println("-----")
}

fn test_move(value int, depth int) int {
	mut best := -1
	mut changed := 0
	mut score := check_winner()
	if score != 0 {
		if score == value {return 1} else {return -1}
	}
	for i in 0..3 {
		for j in 0..3 {
			if b[i][j] != 0 {continue}
			b[i][j] = value
			changed = value
			score = -test_move(-value, depth + 1)
			b[i][j] = 0
			if score <= best {continue}
			if depth == 0 {
				best_i = i
				best_j = j
			}
			best = score
		}
	}
	if changed != 0 {return best}
	return 0
}
