import gleam/int
import gleam/io
import gleam/list

pub fn main() {
  let cases = [
    [1, 5, 3, 7, 2],
    [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
    [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
    [5, 5, 5, 5],
    [5, 6, 7, 8],
    [8, 7, 7, 6],
    [6, 7, 10, 7, 6],
  ]
  use towers <- list.each(cases)
  towers |> water_area |> int.to_string |> io.println
}

pub fn water_area(towers: List(Int)) -> Int {
  towers
  |> list.scan(0, int.max)
  |> list.map2(
    towers |> list.reverse |> list.scan(0, int.max) |> list.reverse,
    int.min,
  )
  |> list.map2(towers, int.subtract)
  |> int.sum
}
