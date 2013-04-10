import std.stdio, std.random, std.string, std.algorithm;

enum TREE_PROB = 0.55; // original tree probability
enum F_PROB =    0.01; // auto combustion probability
enum P_PROB =    0.01; // tree creation probability

enum Cell : char { empty=' ', tree='T', fire='#' }
alias Cell[][] World;

bool hasBurningNeighbours(in World world, in int r, in int c)
pure nothrow {
  foreach (rowShift; -1 .. 2)
    foreach (colShift; -1 .. 2)
      if ((r + rowShift) >= 0 && (r + rowShift) < world.length &&
          (c + colShift) >= 0 && (c + colShift) < world[0].length &&
        world[r + rowShift][c + colShift] == Cell.fire)
      return true;
  return false;
}

void nextState(in World world, World nextWorld) {
  foreach (r, row; world)
    foreach (c, elem; row)
      final switch (elem) {
        case Cell.empty:
          nextWorld[r][c]= uniform(0.,1.)<P_PROB?Cell.tree:Cell.empty;
          break;

        case Cell.tree:
          if (world.hasBurningNeighbours(r, c))
            nextWorld[r][c] = Cell.fire;
          else
            nextWorld[r][c]=uniform(0.,1.)<F_PROB?Cell.fire:Cell.tree;
          break;

        case Cell.fire:
          nextWorld[r][c] = Cell.empty;
          break;
      }
}

void main() {
  auto world = new World(8, 65);
  foreach (row; world)
    foreach (ref el; row)
      el = uniform(0.0, 1.0) < TREE_PROB ? Cell.tree : Cell.empty;
  auto nextWorld = new World(world.length, world[0].length);

  foreach (i; 0 .. 4) {
    nextState(world, nextWorld);
    writeln(join(cast(string[])nextWorld, "\n"), "\n");
    swap(world, nextWorld);
  }
}
