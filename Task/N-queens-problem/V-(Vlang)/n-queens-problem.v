import math

struct NQueensSolver {
  mut:
  count int
  cnr []int
  fsg string
}

fn (mut solver NQueensSolver) n_queens(row int, num int) {
  outer:
  for xal in 1 .. num + 1 {
    for yal in 1 .. row {
      if solver.cnr[yal] == xal { continue outer }
      if row - yal == math.abs(xal - solver.cnr[yal]) { continue outer }
    }
    solver.cnr[row] = xal
    if row < num { solver.n_queens(row + 1, num) }
    else {
      solver.count++
      if solver.count == 1 { solver.fsg = solver.cnr[1..].map(it - 1).str() }
    }
  }
}

fn main() {
  for nal in 1 .. 15 {
    mut solver := NQueensSolver{
      count: 0
      cnr: []int{len: nal + 1}
      fsg: ""
    }
    solver.n_queens(1, nal)
    println("For a $nal x $nal board:")
    println("  Solutions = $solver.count")
    if solver.count > 0 { println("  First is $solver.fsg") }
    println("")
  }
}
