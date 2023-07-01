import ceylon.random { DefaultRandom }

abstract class Cell() of tree | dirt | burning {}
object tree extends Cell() { string => "A"; }
object dirt extends Cell() { string => " "; }
object burning extends Cell() { string => "#"; }

class Forest(Integer width, Integer height, Float f, Float p) {

    value random = DefaultRandom();
    function chance(Float probability) => random.nextFloat() < probability;
    value sparked => chance(f);
    value sprouted => chance(p);

    alias Point => Integer[2];
    interface Row => {Cell*};

    object doubleBufferedGrid satisfies
            Correspondence<Point, Cell> &
            KeyedCorrespondenceMutator<Point, Cell> {

        value grids = [
            Array {
                for (j in 0:height)
                Array {
                    for (i in 0:width)
                    chance(0.5) then tree else dirt
                }
            },
            Array {
                for (j in 0:height)
                Array.ofSize(width, dirt)
            }
        ];

        variable value showFirst = true;
        value currentState => showFirst then grids.first else grids.last;
        value nextState => showFirst then grids.last else grids.first;

        shared void swapStates() => showFirst = !showFirst;

        shared {Row*} rows => currentState;

        shared actual Boolean defines(Point key) =>
                let (x = key[0], y = key[1])
                0 <= x < width && 0 <= y < height;
        shared actual Cell? get(Point key) =>
                let (x = key[0], y = key[1])
                currentState.get(y)?.get(x);

        shared actual void put(Point key, Cell cell) {
            value [x, y] = key;
            nextState.get(y)?.set(x, cell);
        }
    }

    variable value evolutions = 0;
    shared Integer generation => evolutions + 1;

    shared void evolve() {

        evolutions++;

        function firesNearby(Integer x, Integer y) => {
            for (j in y - 1 : 3)
            for (i in x - 1 : 3)
            doubleBufferedGrid[[i, j]]
        }.coalesced.any(burning.equals);

        for(j->row in doubleBufferedGrid.rows.indexed) {
            for(i->cell in row.indexed) {
                switch (cell)
                case (burning) {
                    doubleBufferedGrid[[i, j]] = dirt;
                }
                case (dirt) {
                    doubleBufferedGrid[[i, j]] = sprouted then tree else dirt;
                }
                case (tree) {
                    doubleBufferedGrid[[i, j]] =
                            firesNearby(i, j) || sparked
                            then burning else tree;
                }
            }
        }

        doubleBufferedGrid.swapStates();
    }

    shared void display() {

        void drawLine() => print("-".repeat(width + 2));

        drawLine();
        for (row in doubleBufferedGrid.rows) {
            process.write("|");
            for (cell in row) {
                process.write(cell.string);
            }
            print("|");
        }
        drawLine();
    }
}

shared void run() {

    value forest = Forest(78, 38, 0.02, 0.03);

    while (true) {

        forest.display();

        print("Generation ``forest.generation``");
        print("Press enter for next generation or q and then enter to quit");

        value input = process.readLine();
        if (exists input, input.trimmed.lowercased == "q") {
            return;
        }

        forest.evolve();
    }
}
