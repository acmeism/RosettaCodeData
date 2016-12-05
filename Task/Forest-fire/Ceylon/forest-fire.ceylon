import ceylon.random {
	
	DefaultRandom
}

class Cell of tree | empty | burning {
	
	shared new tree {}
	shared new empty {}
	shared new burning {}
}

class Forest(Integer width, Integer height, Float f, Float p) {
	
	value random = DefaultRandom();
	function chance(Float probability) => random.nextFloat() < probability;
	
	object doubleBufferedGrid satisfies Iterable<Array<Cell>, Null> {
		
		function makeGrid(Cell|Cell() initialValue) => [
			for(j in 0:height)
			Array {
				for(i in 0:width)
				switch(initialValue)
				case(is Cell) initialValue
				case(is Cell()) initialValue()
			}
		];
		
		value grids = [
			makeGrid(() =>
				if(chance(0.5))
				then Cell.tree
				else Cell.empty),
			makeGrid(Cell.empty)
		];
		
		variable value firstIsFront = true;
		value front => firstIsFront then grids.first else grids.last;
		value back => firstIsFront then grids.last else grids.first;
		
		iterator() => front.iterator();
		shared Cell? get(Integer x, Integer y) => front[y]?.get(x);
		shared void set(Integer x, Integer y, Cell cell) => back[y]?.set(x, cell);
		shared void flip() => firstIsFront = !firstIsFront;
	}
	
	shared void evolve() {
		
		function fireNearby(Integer x, Integer y) {
			for(i in -1..1) {
				for(j in -1..1) {
					if(i == 0 && j == 0) {
						continue;
					}
					if(exists cell = doubleBufferedGrid.get(x + i, y + j),
							cell == Cell.burning) {
						return true;
					}
				}
			}
			return false;
		}
		
		for(j->row in doubleBufferedGrid.indexed) {
			for(i->cell in row.indexed) {
				switch(cell)
				case(Cell.burning) {
					doubleBufferedGrid.set(i, j, Cell.empty);
				}
				case(Cell.empty) {
					value nextCell = chance(p) then Cell.tree else Cell.empty;
					doubleBufferedGrid.set(i, j, nextCell);
				}
				case(Cell.tree) {
					value nextCell =
							fireNearby(i, j) || chance(f)
							then Cell.burning
							else Cell.tree;
					doubleBufferedGrid.set(i, j, nextCell);
				}
			}
		}
		
		doubleBufferedGrid.flip();
	}
	
	shared void display() {
		
		void drawLine() => print("-".repeat(width + 2));
		
		drawLine();
		for(row in doubleBufferedGrid) {
			process.write("|");
			for(cell in row) {
				switch(cell)
				case(Cell.empty) {
					process.write(" ");
				}
				case(Cell.tree) {
					process.write("A");
				}
				case(Cell.burning) {
					process.write("#");
				}
			}
			print("|");
		}
		drawLine();
	}
}

shared void run() {
	
	value forest = Forest(78, 38, 0.02, 0.03);
	variable value generation = 1;
	
	while(true) {
		
		forest.display();
		forest.evolve();
		
		print("Generation ``generation++``
		       Press enter for next generation or q and then enter to quit");
		
		value input = process.readLine();
		if(exists input) {
			switch(input.trimmed)
			case("q" | "Q") {
				return;
			}
			else {}
		}
	}
}
