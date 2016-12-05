shared void run() {
	
	class Automata1D<Cell>({Cell*} data, Cell alive, Cell dead)
		given Cell satisfies Object {
		
		assert(data.every((Cell element) => element == alive || element == dead));
		
		value imaginaryFirstCell = data.first else dead;
		value imaginaryLastCell = data.last else dead;

		value cells = Array {*data.rest.exceptLast};
		
		function isAlive(Cell c) => c == alive;
		function flipped(Cell c) => c == alive then dead else alive;
		
		shared Boolean evolve() {
			value buffer = Array {
				*cells.indexed.map((Integer->Cell element) {
					value index->cell = element;
					value left = cells[index - 1] else imaginaryFirstCell;
					value right = cells[index + 1] else imaginaryLastCell;
					if(isAlive(left) && isAlive(right)) {
						return flipped(cell);
					}
					if(isAlive(cell) && !isAlive(left) && !isAlive(right)) {
						return dead;
					}
					return cell;
				}
			)};
			value changed = buffer != cells;
			buffer.copyTo(cells);
			return changed;
		}
		
		string => imaginaryFirstCell.string + "".join(cells) + imaginaryLastCell.string;
	}

	value automata = Automata1D("_###_##_#_#_#_#__#__", '#', '_');
	variable value generation = 0;
	print("generation ``generation`` ``automata``");
	while(automata.evolve() && generation < 10) {
		print("generation ``++generation`` ``automata``");
	}
}
