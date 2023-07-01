class Rule(number) satisfies Correspondence<Boolean[3], Boolean> {
	
	shared Byte number;
	
	"all 3 bit patterns will return a value so this is always true"
	shared actual Boolean defines(Boolean[3] key) => true;
	
	shared actual Boolean? get(Boolean[3] key) =>
			number.get((key[0] then 4 else 0) + (key[1] then 2 else 0) + (key[2] then 1 else 0));
	
	function binaryString(Integer integer, Integer maxPadding) =>
			Integer.format(integer, 2).padLeading(maxPadding, '0');
	
	string =>
			let (digits = binaryString(number.unsigned, 8))
			"Rule #``number``
			 ``" | ".join { for (pattern in $111..0) binaryString(pattern, 3) }``
			 ``" | ".join(digits.map((Character element) => element.string.pad(3)))``";
}

class ElementaryAutomaton {
	
	shared static ElementaryAutomaton|ParseException parse(Rule rule, String cells, Character aliveChar, Character deadChar) {
		if (!cells.every((Character element) => element == aliveChar || element == deadChar)) {
			return ParseException("the string was not a valid automaton");
		}
		return ElementaryAutomaton(rule, cells.map((Character element) => element == aliveChar));
	}

	shared Rule rule;
	
	Array<Boolean> cells;
	
	shared new(Rule rule, {Boolean*} initialCells) {
		this.rule = rule;
		this.cells = Array { *initialCells };
	}
	
	shared Boolean evolve() {
		
		if (cells.empty) {
			return false;
		}
		
		function left(Integer index) {
			assert (exists cell = cells[index - 1] else cells.last);
			return cell;
		}

		function right(Integer index) {
			assert (exists cell = cells[index + 1] else cells.first);
			return cell;
		}
		
		value newCells = Array.ofSize(cells.size, false);
		for (index->cell in cells.indexed) {
			value neighbourhood = [left(index), cell, right(index)];
			assert (exists newCell = rule[neighbourhood]);
			newCells[index] = newCell;
		}

		if (newCells == cells) {
			return false;
		}
		
		newCells.copyTo(cells);
		return true;	
	}
	
	shared void display(Character aliveChar = '#', Character deadChar = ' ') {
		print("".join(cells.map((Boolean element) => element then aliveChar else deadChar)));
	}
}

shared void run() {
	value rule = Rule(90.byte);
	print(rule);
	
	value automaton = ElementaryAutomaton.parse(rule, "          #          ", '#', ' ');
	assert (is ElementaryAutomaton automaton);
	
	for (generation in 0..10) {
		automaton.display();
		automaton.evolve();
	}
}
