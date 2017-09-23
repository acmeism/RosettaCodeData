abstract class Cell(shared Character char) of emptyCell | head | tail | conductor {

    shared Cell output({Cell*} neighbors) =>
            switch (this)
            case (emptyCell) emptyCell
            case (head) tail
            case (tail) conductor
            case (conductor) (neighbors.count(head.equals) in 1..2 then head else conductor);

    string => char.string;
}

object emptyCell extends Cell(' ') {}

object head extends Cell('H') {}

object tail extends Cell('t') {}

object conductor extends Cell('.') {}

Map<Character,Cell> cellsByChar = map { for (cell in `Cell`.caseValues) cell.char->cell };

class Wireworld(String data) {

    value lines = data.lines;

    value width = max(lines*.size);
    value height = lines.size;

    function toIndex(Integer x, Integer y) => x + y * width;

    variable value currentState = Array.ofSize(width * height, emptyCell);
    variable value nextState = Array.ofSize(width * height, emptyCell);

    for (j->line in lines.indexed) {
        for (i->char in line.indexed) {
            currentState[toIndex(i, j)] = cellsByChar[char] else emptyCell;
        }
    }

    value emptyGrid = Array.ofSize(width * height, emptyCell);
    void clear(Array<Cell> cells) => emptyGrid.copyTo(cells);

    shared void update() {
        clear(nextState);
        for(j in 0:height) {
            for(i in 0:width) {
                if(exists cell = currentState[toIndex(i, j)]) {
                    value nextCell = cell.output(neighborhood(currentState, i, j));
                    nextState[toIndex(i, j)] = nextCell;
                }
            }
        }
        value temp = currentState;
        currentState = nextState;
        nextState = temp;
    }

    shared void display() {
        for (row in currentState.partition(width)) {
            print("".join(row));
        }
    }

    shared {Cell*} neighborhood(Array<Cell> grid, Integer x, Integer y) => {
                for (j in y - 1..y + 1)
                for (i in x - 1..x + 1)
                if(i in 0:width && j in 0:height)
                grid[toIndex(i, j)]
            }.coalesced;

}

shared void run() {
    value data = "tH.........
                  .   .
                     ...
                  .   .
                  Ht.. ......";

    value world = Wireworld(data);

    variable value generation = 0;

    void display() {
        print("generation: ``generation``");
        world.display();
    }

    display();

    while (true) {
        if (exists input = process.readLine(), input.lowercased == "q") {
            return;
        }
        world.update();
        generation++;
        display();

    }
}
