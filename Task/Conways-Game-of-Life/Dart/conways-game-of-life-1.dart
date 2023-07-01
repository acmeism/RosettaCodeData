/**
* States of a cell. A cell is either [ALIVE] or [DEAD].
* The state contains its [symbol] for printing.
*/
class State {
  const State(this.symbol);

  static final ALIVE = const State('#');
  static final DEAD = const State(' ');

  final String symbol;
}

/**
* The "business rule" of the game. Depending on the count of neighbours,
* the [cellState] changes.
*/
class Rule {
  Rule(this.cellState);

  reactToNeighbours(int neighbours) {
    if (neighbours == 3) {
      cellState = State.ALIVE;
    } else if (neighbours != 2) {
      cellState = State.DEAD;
    }
  }

  var cellState;
}

/**
* A coordinate on the [Grid].
*/
class Point {
  const Point(this.x, this.y);

  operator +(other) => new Point(x + other.x, y + other.y);

  final int x;
  final int y;
}

/**
* List of the relative indices of the 8 cells around a cell.
*/
class Neighbourhood {
  List<Point> points() {
    return [
      new Point(LEFT, UP), new Point(MIDDLE, UP), new Point(RIGHT, UP),
      new Point(LEFT, SAME), new Point(RIGHT, SAME),
      new Point(LEFT, DOWN), new Point(MIDDLE, DOWN), new Point(RIGHT, DOWN)
    ];
  }

  static final LEFT = -1;
  static final MIDDLE = 0;
  static final RIGHT = 1;
  static final UP = -1;
  static final SAME = 0;
  static final DOWN = 1;
}

/**
* The grid is an endless, two-dimensional [field] of cell [State]s.
*/
class Grid {
  Grid(this.xCount, this.yCount) {
    _field = new Map();
    _neighbours = new Neighbourhood().points();
  }

  set(point, state) {
    _field[_pos(point)] = state;
  }

  State get(point) {
    var state = _field[_pos(point)];
    return state != null ? state : State.DEAD;
  }

  int countLiveNeighbours(point) =>
    _neighbours.filter((offset) => get(point + offset) == State.ALIVE).length;

  _pos(point) => '${(point.x + xCount) % xCount}:${(point.y + yCount) % yCount}';

  print() {
    var sb = new StringBuffer();
    iterate((point) { sb.add(get(point).symbol); }, (x) { sb.add("\n"); });
    return sb.toString();
  }

  iterate(eachCell, [finishedRow]) {
    for (var x = 0; x < xCount; x++) {
      for (var y = 0; y < yCount; y++) {
         eachCell(new Point(x, y));
      }
      if(finishedRow != null) {
        finishedRow(x);
      }
    }
  }

  final xCount, yCount;
  List<Point> _neighbours;
  Map<String, State> _field;
}

/**
* The game updates the [grid] in each step using the [Rule].
*/
class Game {
  Game(this.grid);

  tick() {
    var newGrid = createNewGrid();

    grid.iterate((point) {
      var rule = new Rule(grid.get(point));
      rule.reactToNeighbours(grid.countLiveNeighbours(point));
      newGrid.set(point, rule.cellState);
    });

    grid = newGrid;
  }

  createNewGrid() => new Grid(grid.xCount, grid.yCount);

  printGrid() => print(grid.print());

  Grid grid;
}

main() {
  // Run the GoL with a blinker.
  runBlinker();
}

runBlinker() {
  var game = new Game(createBlinkerGrid());

  for(int i = 0; i < 3; i++) {
    game.printGrid();
    game.tick();
  }
  game.printGrid();
}

createBlinkerGrid() {
  var grid = new Grid(4, 4);
  loadBlinker(grid);
  return grid;
}

loadBlinker(grid) => blinkerPoints().forEach((point) => grid.set(point, State.ALIVE));

blinkerPoints() => [new Point(0, 1), new Point(1, 1), new Point(2, 1)];
