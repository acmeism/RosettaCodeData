import ceylon.random {

	DefaultRandom
}

class Cell() {
	
	shared variable Boolean covered = true;
	shared variable Boolean flagged = false;
	shared variable Boolean mined = false;
	shared variable Integer adjacentMines = 0;
	
	string =>
			if (covered && !flagged)
			then "."
			else if (covered && flagged)
			then "?"
			else if (!covered && mined)
			then "X"
			else if (!covered && adjacentMines > 0)
			then adjacentMines.string
			else " ";
}

"The main function of the module. Run this one."
shared void run() {
	
	value random = DefaultRandom();
	value chanceOfBomb = 0.2;
	
	value width = 6;
	value height = 4;
	
	value grid = Array { for (j in 1..height) Array { for (i in 1..width) Cell() } };
	
	function getCell(Integer x, Integer y) => grid[y]?.get(x);
	
	void initializeGrid() {
		
		for (row in grid) {
			for (cell in row) {
				cell.covered = true;
				cell.flagged = false;
				cell.mined = random.nextFloat() < chanceOfBomb;
			}
		}
		
		function countAdjacentMines(Integer x, Integer y) => count {
			for (j in y - 1 .. y + 1)
			for (i in x - 1 .. x + 1)
			if (exists cell = getCell(i, j))
			cell.mined
		};
		
		for (j->row in grid.indexed) {
			for (i->cell in row.indexed) {
				cell.adjacentMines = countAdjacentMines(i, j);
			}
		}
	}
	
	void displayGrid() {
		print("  " + "".join(1..width));
		print("  " + "-".repeat(width));
		for (j->row in grid.indexed) {
			print("``j + 1``|``"".join(row)``|``j + 1``");
		}
		print("  " + "-".repeat(width));
		print("  " + "".join(1..width));
	}
	
	Boolean won() =>
		expand(grid).every((cell) => (cell.flagged && cell.mined) || (!cell.flagged && !cell.mined));

	void uncoverNeighbours(Integer x, Integer y) {
		for (j in y - 1 .. y + 1) {
			for (i in x - 1 .. x + 1) {
				if (exists cell = getCell(i, j), cell.covered, !cell.flagged, !cell.mined) {
					cell.covered = false;
					if (cell.adjacentMines == 0) {
						uncoverNeighbours(i, j);
					}
				}
			}
		}
	}
	
	while (true) {
		print("Welcome to minesweeper!
		       -----------------------");
		initializeGrid();
		while (true) {
			displayGrid();
			print("
			       The number of mines to find is ``count(expand(grid)*.mined)``.
			       What would you like to do?
			       [1] reveal a free space (or blow yourself up)
			       [2] mark (or unmark) a mine");
			assert (exists instruction = process.readLine());
			print("Please enter the coordinates. eg 2 4");
			assert (exists line2 = process.readLine());
			value coords = line2.split().map(Integer.parse).narrow<Integer>().sequence();
			if (exists x = coords[0], exists y = coords[1], exists cell = getCell(x - 1, y - 1)) {
				switch (instruction)
				case ("1") {
					if (cell.mined) {
						print("=================
						       === You lose! ===
						       =================");
						expand(grid).each((cell) => cell.covered = false);
						displayGrid();
						break;
					}
					else if (cell.covered) {
						cell.covered = false;
						uncoverNeighbours(x - 1, y - 1);
					}
				}
				case ("2") {
					if (cell.covered) {
						cell.flagged = !cell.flagged;
					}
				}
				else { print("bad choice"); }
				if (won()) {
					print("****************
					       *** You win! ***
					       ****************");
					break;
				}
			}
		}
	}
}
