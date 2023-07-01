import std.stdio, std.random, std.algorithm, std.typetuple,
       simpledisplay;

enum double TREE_PROB = 0.55; // Original tree probability.
enum double F_PROB =    0.01; // Auto combustion probability.
enum double P_PROB =    0.01; // Tree creation probability.
enum worldSide = 600;

enum Cell : ubyte { empty, tree, burning }
alias World = Cell[worldSide][];

immutable white = Color(255, 255, 255),
          red = Color(255, 0, 0),
          green = Color(0, 255, 0);

void nextState(ref World world, ref World nextWorld,
               ref Xorshift rnd, Image img) {
  immutable nr = world.length;
  immutable nc = world[0].length;
  foreach (immutable r, const row; world)
    foreach (immutable c, immutable elem; row)
      START: final switch (elem) with (Cell) {
        case empty:
          img.putPixel(c, r, white);
          nextWorld[r][c] = rnd.uniform01 < P_PROB ? tree : empty;
          break;

        case tree:
          img.putPixel(c, r, green);

          foreach (immutable rowShift; TypeTuple!(-1, 0, 1))
            foreach (immutable colShift; TypeTuple!(-1, 0, 1))
              if ((r + rowShift) >= 0 && (r + rowShift) < nr &&
                  (c + colShift) >= 0 && (c + colShift) < nc &&
                  world[r + rowShift][c + colShift] == Cell.burning) {
                nextWorld[r][c] = Cell.burning;
                break START;
              }

          nextWorld[r][c]= rnd.uniform01 < F_PROB ? burning : tree;
          break;

        case burning:
          img.putPixel(c, r, red);
          nextWorld[r][c] = empty;
          break;
      }

  swap(world, nextWorld);
}

void main() {
  auto rnd = Xorshift(1);
  auto world = new World(worldSide);
  foreach (ref row; world)
    foreach (ref el; row)
      el = rnd.uniform01 < TREE_PROB ? Cell.tree : Cell.empty;
  auto nextWorld = new World(world[0].length);

  auto w= new SimpleWindow(world.length,world[0].length,"ForestFire");
  auto img = new Image(w.width, w.height);

  w.eventLoop(1, {
    auto painter = w.draw;
    nextState(world, nextWorld, rnd, img);
    painter.drawImage(Point(0, 0), img);
  });
}
