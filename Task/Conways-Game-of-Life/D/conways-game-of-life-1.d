import std.stdio,std.string,std.algorithm,std.typetuple,std.array;

struct GameOfLife {
  enum Cell : char { dead = ' ', alive = '#' }
  Cell[][] grid, newGrid;

  this(in int x, in int y) pure nothrow {
    grid = new typeof(grid)(y + 2, x + 2);
    newGrid = new typeof(grid)(y + 2, x + 2);
  }

  void opIndexAssign(in string[] v, in size_t y, in size_t x)
  pure nothrow {
    foreach (nr, row; v)
      foreach (nc, state; row) {
        //grid[y + nr][x + nc] = to!Cell(state);
        assert(state == Cell.dead || state == Cell.alive);
        grid[y + nr][x + nc] = cast(Cell)state;
      }
  }

  void iteration() pure nothrow {
    newGrid[0][] = Cell.dead;
    newGrid[$ - 1][] = Cell.dead;
    foreach (row; newGrid)
      row[0] = row[$ - 1] = Cell.dead;

    foreach (r; 1 .. grid.length - 1)
      foreach (c; 1 .. grid[0].length - 1) {
        int count = 0;
        foreach (i; -1 .. 2)
          foreach (j; -1 .. 2)
            if (i != 0 || j != 0)
              count += grid[r + i][c + j] == Cell.alive;
        auto a = count == 3 ||
                 (count == 2 && grid[r][c] == Cell.alive);
        newGrid[r][c] = a ? Cell.alive : Cell.dead;
      }

    swap(grid, newGrid);
  }

  string toString() const pure nothrow {
    string ret = "-".replicate(grid[0].length - 1) ~ "\n";
    foreach (row; grid[1 .. $ - 1])
      ret ~= "|" ~ cast(char[])row[1 .. $-1] ~ "|\n";
    return ret ~ "-".replicate(grid[0].length - 1);
  }
}
void main() {
  immutable glider1 = ["  #", "# #", " ##"];
  immutable glider2 = ["#  ", "# #", "## "];

  auto uni = GameOfLife(60, 20);
  uni[3,  2] = glider1;
  uni[3, 15] = glider2;
  uni[3, 19] = glider1;
  uni[3, 32] = glider2;
  uni[5, 50] = [" #  #", "#  ", "#   #", "#### "];
  writeln(uni);

  foreach (i; 0 .. 20) {
    uni.iteration();
    writeln(uni);
  }
}
