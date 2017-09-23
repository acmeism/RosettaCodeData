import Darwin

enum Token : CustomStringConvertible {
	case cross, circle
	
	func matches(tokens: [Token?]) -> Bool {
		for token in tokens {
			guard let t = token, t == self else {
				return false
			}
		}
		return true
	}
	
	func emptyCell(in tokens: [Token?]) -> Int? {
		if tokens[0] == nil
		&& tokens[1] == self
		&& tokens[2] == self {
			return 0
		} else
		if tokens[0] == self
		&& tokens[1] == nil
		&& tokens[2] == self {
			return 1
		} else
		if tokens[0] == self
		&& tokens[1] == self
		&& tokens[2] == nil {
			return 2
		}
		return nil
	}
	
	var description: String {
		switch self {
			case .cross: return "x"
			case .circle: return "o"
		}
	}
}

struct Board {
	var cells: [Token?] = [nil, nil, nil, nil, nil, nil, nil, nil, nil]
	
	func cells(atCol col: Int) -> [Token?] {
		return [cells[col], cells[col + 3], cells[col + 6]]
	}
	
	func cells(atRow row: Int) -> [Token?] {
		return [cells[row * 3], cells[row * 3 + 1], cells[row * 3 + 2]]
	}
	
	func cellsTopLeft() -> [Token?] {
		return [cells[0], cells[4], cells[8]]
	}
	
	func cellsBottomLeft() -> [Token?] {
		return [cells[6], cells[4], cells[2]]
	}
	
	func winner() -> Token? {
		let r0 = cells(atRow: 0)
		let r1 = cells(atRow: 1)
		let r2 = cells(atRow: 2)
		let c0 = cells(atCol: 0)
		let c1 = cells(atCol: 1)
		let c2 = cells(atCol: 2)
		let tl = cellsTopLeft()
		let bl = cellsBottomLeft()
		
		if Token.cross.matches(tokens: r0)
		|| Token.cross.matches(tokens: r1)
		|| Token.cross.matches(tokens: r2)
		|| Token.cross.matches(tokens: c0)
		|| Token.cross.matches(tokens: c1)
		|| Token.cross.matches(tokens: c2)
		|| Token.cross.matches(tokens: tl)
		|| Token.cross.matches(tokens: bl) {
			return .cross
		} else
		if Token.circle.matches(tokens: r0)
		|| Token.circle.matches(tokens: r1)
		|| Token.circle.matches(tokens: r2)
		|| Token.circle.matches(tokens: c0)
		|| Token.circle.matches(tokens: c1)
		|| Token.circle.matches(tokens: c2)
		|| Token.circle.matches(tokens: tl)
		|| Token.circle.matches(tokens: bl) {
			return .circle
		}
		return nil
	}
	
	func atCapacity() -> Bool {
		return cells.filter { $0 == nil }.count == 0
	}
	
	mutating func play(token: Token, at location: Int) {
		cells[location] = token
	}
	
	func findBestLocation(for player: Token) -> Int? {
		let r0 = cells(atRow: 0)
		let r1 = cells(atRow: 1)
		let r2 = cells(atRow: 2)
		let c0 = cells(atCol: 0)
		let c1 = cells(atCol: 1)
		let c2 = cells(atCol: 2)
		let tl = cellsTopLeft()
		let bl = cellsBottomLeft()
		
		if let cell = player.emptyCell(in: r0) {
			return cell
		} else if let cell = player.emptyCell(in: r1) {
			return cell + 3
		} else if let cell = player.emptyCell(in: r2) {
			return cell + 6
		} else if let cell = player.emptyCell(in: c0) {
			return cell * 3
		} else if let cell = player.emptyCell(in: c1) {
			return cell * 3 + 1
		} else if let cell = player.emptyCell(in: c2) {
			return cell * 3 + 2
		} else if let cell = player.emptyCell(in: tl) {
			return cell == 0 ? 0 : (cell == 1 ? 4 : 8)
		} else if let cell = player.emptyCell(in: bl) {
			return cell == 0 ? 6 : (cell == 1 ? 4 : 2)
		}
		return nil
	}
	
	func findMove() -> Int {
		let empties = cells.enumerated().filter { $0.1 == nil }
		let r = Int(arc4random()) % empties.count
		return empties[r].0
	}
}

extension Board : CustomStringConvertible {
	var description: String {
		var result = "\n---------------\n"
		for (idx, cell) in cells.enumerated() {
			if let cell = cell {
				result += "| \(cell) |"
			} else {
				result += "| \(idx) |"
			}
			
			if (idx + 1) % 3 == 0 {
				result += "\n---------------\n"
			}
		}
		return result
	}
}

while true {
	var board = Board()
	print("Who do you want to play as ('o' or 'x'): ", separator: "", terminator: "")
	let answer = readLine()?.characters.first ?? "x"
	
	var player: Token = answer == "x" ? .cross : .circle
	var pc: Token = player == .cross ? .circle : .cross
	
	print(board)
	
	while true {
		print("Choose cell to play on: ", separator: "", terminator: "")
		var pos = Int(readLine() ?? "0") ?? 0
		while !board.atCapacity() && board.cells[pos] != nil {
			print("Invalid move. Choose cell to play on: ", separator: "", terminator: "")
			pos = Int(readLine() ?? "0") ?? 0
		}
		
		if board.atCapacity() {
			print("Draw")
			break
		}
		
		board.play(token: player, at: pos)
		print(board)
		
		if let winner = board.winner() {
			print("winner is \(winner)")
			break
		} else if board.atCapacity() {
			print("Draw")
			break
		}
		
		if let win = board.findBestLocation(for: pc) {
			board.play(token: pc, at: win)
		} else if let def = board.findBestLocation(for: player) {
			board.play(token: pc, at: def)
		} else {
			board.play(token: pc, at: board.findMove())
		}
		
		print(board)
		
		if let winner = board.winner() {
			print("winner is \(winner)")
			break
		}
	}
}
