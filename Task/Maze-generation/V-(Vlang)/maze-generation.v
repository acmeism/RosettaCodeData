import rand
import os

struct Direction {
   bit int
   dx  int
   dy  int
}

struct MazeGenerator {
   x         int
   y         int
   mut:
   maze      [][]int
   directions []Direction
   opposites map[int]Direction
}

fn new_maze_generator(x int, y int) MazeGenerator {
   mut maze := [][]int{len: x}
   for i in 0 .. x {
      maze[i] = []int{len: y, init: 0}
   }
   directions := [Direction{bit: 1, dx: 0, dy: -1}, Direction{bit: 2, dx: 0, dy: 1},
      Direction{bit: 4, dx: 1, dy: 0}, Direction{bit: 8, dx: -1, dy: 0}]
   opposites := {
      1: directions[1] // N.opposite = S
      2: directions[0] // S.opposite = N
      4: directions[3] // E.opposite = W
      8: directions[2] // W.opposite = E
   }
   return MazeGenerator{
      x: x
      y: y
      maze: maze
      directions: directions
      opposites: opposites
   }
}

fn (mg MazeGenerator) between(v int, upper int) bool {
   return v >= 0 && v < upper
}

fn (mg MazeGenerator) directions_shuffled() ![]Direction {
   mut dirs := mg.directions.clone()
   rand.shuffle(mut dirs) or {0}
   return dirs
}

fn (mut mg MazeGenerator) generate(cx int, cy int) {
   mut shuf := mg.directions_shuffled() or {return}
   for dir in shuf {
      nx := cx + dir.dx
      ny := cy + dir.dy
      if mg.between(nx, mg.x) && mg.between(ny, mg.y) && mg.maze[nx][ny] == 0 {
         mg.maze[cx][cy] |= dir.bit
         opp := mg.opposites[dir.bit] or { panic("Opposite direction not found") }
         mg.maze[nx][ny] |= opp.bit
         mg.generate(nx, ny)
      }
   }
}

fn (mg MazeGenerator) display() {
   for i in 0 .. mg.y {
      for j in 0 .. mg.x {
         if (mg.maze[j][i] & 1) == 0 { print("+---") }
         else { print("+   ") }
      }
      println("+")
      for j in 0 .. mg.x {
         if (mg.maze[j][i] & 8) == 0 { print("|   ") }
         else { print("    ") }
      }
      println("|")
   }
   for _ in 0 .. mg.x {
      print("+---")
   }
   println("+")
}

fn main() {
   args := os.args
   mut x := 8
   mut y := 8
   mut mg := new_maze_generator(x, y)
   if args.len >= 2 { x = args[1].int() }
   if args.len >= 3 { y = args[2].int() }
   mg.generate(0, 0)
   mg.display()
}
