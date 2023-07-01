class GameOfLife {

	int generations
	int dimensions
	def board
	
	GameOfLife(generations = 5, dimensions = 5) {
		this.generations = generations
		this.dimensions = dimensions
		this.board = createBlinkerBoard()
	}

	static def createBlinkerBoard() {
		[
			[].withDefault{0},
			[0,0,1].withDefault{0},
			[0,0,1].withDefault{0},
			[0,0,1].withDefault{0}
		].withDefault{[]}
	}

	static def createGliderBoard() {
		[
			[].withDefault{0},
			[0,0,1].withDefault{0},
			[0,0,0,1].withDefault{0},
			[0,1,1,1].withDefault{0}
		].withDefault{[]}
	}

	static def getValue(board, point) {
		def x,y
		(x,y) = point
		if(x < 0 || y < 0) {
			return 0
		}
		board[x][y] ? 1 : 0
	}
	
	static def countNeighbors(board, point) {
		def x,y
		(x,y) = point
		def neighbors = 0
		neighbors += getValue(board, [x-1,y-1])
		neighbors += getValue(board, [x-1,y])
		neighbors += getValue(board, [x-1,y+1])
		neighbors += getValue(board, [x,y-1])
		neighbors += getValue(board, [x,y+1])
		neighbors += getValue(board, [x+1,y-1])
		neighbors += getValue(board, [x+1,y])
		neighbors += getValue(board, [x+1,y+1])
		neighbors
	}

	static def conwaysRule(currentValue, neighbors) {
		def newValue = 0
		if(neighbors == 3 || (currentValue && neighbors == 2)) {
			newValue = 1
		}
		newValue
	}
	
	static def createNextGeneration(currentBoard, dimensions) {
		def newBoard = [].withDefault{[].withDefault{0}}
		(0..(dimensions-1)).each { row ->
			(0..(dimensions-1)).each { column ->
				def point = [row, column]
				def currentValue = getValue(currentBoard, point)
				def neighbors = countNeighbors(currentBoard, point)
				newBoard[row][column] = conwaysRule(currentValue, neighbors)
			}
		}
		newBoard
	}

	static def printBoard(generationCount, board, dimensions) {
		println "Generation ${generationCount}"
		println '*' * 80
		(0..(dimensions-1)).each { row ->
			(0..(dimensions-1)).each { column ->
				print board[row][column] ? 'X' : '.'
			}
			print System.getProperty('line.separator')
		}
		println ''
	}
	
	def start() {
		(1..generations).each { generation ->
			printBoard(generation, this.board, this.dimensions)
			this.board = createNextGeneration(this.board, this.dimensions)
		}
	}
	
}

// Blinker
def game = new GameOfLife()
game.start()

// Glider
game = new GameOfLife(10, 10)
game.board = game.createGliderBoard()
game.start()
