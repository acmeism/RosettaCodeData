func solving(board: [[Int]]) -> [[Int]] {
	var board = board
	var isSolved = false
	while !isSolved {
		for x in 0 ..< 9  {
			for y in 0 ..< 9 {
				if board[x][y] == 0 {
					let known = Set(board.map { $0[y] } + board[x] + subgrid(board, pos: (x, y)))
					let possible = Set(Array(1...9)).subtracting(known)
					if possible.count == 1  {
						board[x][y] = possible.first!
					}
				}
			}
			isSolved = 45 == board[x].reduce(0, +)
		}
	}
	return board
}

func subgrid(_ board: [[Int]], pos: (Int, Int)) -> [Int] {
	var r = [Int]()
	var (x, y) = pos
	x = x / 3 * 3
	y = y / 3 * 3
	for i in x ..< x + 3 {
		for j in y ..< y + 3 {
			r.append(board[i][j])
		}
	}
	return r
}

func print(_ board: [[Int]]) {
	for i in board.indices {
		if i % 9 == 0 {
			print(" -------------------")
		}
		for j in board.indices {
			if j % board.count == 0 {
				print("| ", terminator: "")
			}
			let digit = board[i][j]
			print(digit != 0 ? digit : " ", terminator: "")
			print(" ", terminator: "")
		}
		print("|")
	}
	print(" -------------------")
}

let puzzle = [
	[0,2,0,4,5,0,7,0,9],
	[0,0,0,1,0,9,0,3,0],
	[0,0,8,0,0,0,1,0,4],
	[0,4,0,0,6,1,0,7,0],
	[5,0,6,0,3,0,0,1,0],
	[0,3,0,0,0,2,0,9,0],
	[3,0,4,0,7,5,0,6,8],
	[0,9,0,0,1,0,3,0,7],
	[0,0,2,0,0,3,0,0,1]
]

print(solving(board: puzzle))
