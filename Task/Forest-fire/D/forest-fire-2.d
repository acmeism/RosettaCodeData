import std.stdio, std.random, std.string, std.algorithm, simpledisplay;

enum double TREE_PROB = 0.55; // original tree probability
enum double F_PROB =    0.01; // auto combustion probability
enum double P_PROB =    0.01; // tree creation probability

template TypeTuple(T...) { alias T TypeTuple; }
alias TypeTuple!(-1, 0, 1) sp;

enum Cell : char { empty=' ', tree='T', burning='#' }
alias Cell[][] World;

immutable white = Color(255, 255, 255),
          red = Color(255, 0, 0),
          green = Color(0, 255, 0);

void nextState(ref World world, ref World nextWorld,
               ref Xorshift rnd, Image img) {
  enum double div = cast(double)typeof(rnd.front()).max;
  immutable nr = world.length;
  immutable nc = world[0].length;
  foreach (r, row; world)
    foreach (c, elem; row)
      final switch (elem) {
        case Cell.empty:
          img.putPixel(c, r, white);
          nextWorld[r][c] = (rnd.front()/div)<P_PROB ? Cell.tree : Cell.empty;
          rnd.popFront();
          break;

        case Cell.tree:
          img.putPixel(c, r, green);

          foreach (rowShift; sp)
            foreach (colShift; sp)
              if ((r + rowShift) >= 0 && (r + rowShift) < nr &&
                  (c + colShift) >= 0 && (c + colShift) < nc &&
                  world[r + rowShift][c + colShift] == Cell.burning) {
                nextWorld[r][c] = Cell.burning;
                goto END;
              }

          nextWorld[r][c]=(rnd.front()/div)<F_PROB ? Cell.burning : Cell.tree;
          rnd.popFront();
          END: break;

        case Cell.burning:
          img.putPixel(c, r, red);
          nextWorld[r][c] = Cell.empty;
          break;
      }

  swap(world, nextWorld);
}

void main() {
  auto rnd = Xorshift(1);
  auto world = new World(600, 600); // create world
  foreach (row; world)
    foreach (ref el; row)
      el = uniform(0.0, 1.0, rnd) < TREE_PROB ? Cell.tree : Cell.empty;
  auto nextWorld = new World(world.length, world[0].length);

  auto w= new SimpleWindow(world.length,world[0].length,"ForestFire");
  auto img = new Image(w.width, w.height);

  w.eventLoop(1, {
    auto painter = w.draw();
    nextState(world, nextWorld, rnd, img);
    painter.drawImage(Point(0, 0), img);
  });
}
