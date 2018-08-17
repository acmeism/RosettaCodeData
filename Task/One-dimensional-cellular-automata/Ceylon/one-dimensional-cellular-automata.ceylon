shared abstract class Cell(character) of alive | dead {
	shared Character character;
	string => character.string;
	shared formal Cell opposite;
}

shared object alive extends Cell('#') {
	opposite => dead;
}
shared object dead extends Cell('_') {
	opposite => alive;
}

shared Map<Character, Cell> cellsByCharacter = map { for (cell in `Cell`.caseValues) cell.character->cell };

shared class Automata1D({Cell*} initialCells) {
	
	
	value permanentFirstCell = initialCells.first else dead;
	value permanentLastCell = initialCells.last else dead;
	
	value cells = Array { *initialCells.rest.exceptLast };
	
	shared Boolean evolve() {
		
		value newCells = Array {
			for (index->cell in cells.indexed)
			let (left = cells[index - 1] else permanentFirstCell,
				right = cells[index + 1] else permanentLastCell,
				neighbours = [left, right],
				bothAlive = neighbours.every(alive.equals),
				bothDead = neighbours.every(dead.equals))
			if (bothAlive)
			then cell.opposite
			else if (cell == alive && bothDead)
			then dead
			else cell
		};
		
		if (newCells == cells) {
			return false;
		}
		
		newCells.copyTo(cells);
		return true;
	}
	
	string => permanentFirstCell.string + "".join(cells) + permanentLastCell.string;
}

shared Automata1D? automata1d(String string) =>
		let (cells = string.map((Character element) => cellsByCharacter[element]))
		if (cells.every((Cell? element) => element exists))
		then Automata1D(cells.coalesced)
		else null;

shared void run() {

	assert (exists automata = automata1d("__###__##_#_##_###__######_###_#####_#__##_____#_#_#######__"));
	
	variable value generation = 0;
	print("generation ``generation`` ``automata``");
	while (automata.evolve() && generation<10) {
		print("generation `` ++generation `` ``automata``");
	}
}
