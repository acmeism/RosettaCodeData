import gleam/int

pub fn main() {
  echo probability(9, 4, 6, 6)
  echo probability(5, 10, 6, 7)
}

/// Returns the probability that rolling `a` dice with `b` sides will
/// have a higher total than rolling `c` dice with `d` sides.
///
pub fn probability(a: Int, b: Int, c: Int, d: Int) -> Float {
  probability_loop(a, b, c, d, 10_000, 0)
}

fn probability_loop(a, b, c, d, iter, wins) -> Float {
  case iter, roll(a, b) > roll(c, d) {
    0, _ -> int.to_float(wins) /. 10_000.0
    _, True -> probability_loop(a, b, c, d, iter - 1, wins + 1)
    _, False -> probability_loop(a, b, c, d, iter - 1, wins)
  }
}

/// Rolls some dice with the given number of sides and returns their total.
///
fn roll(dice: Int, sides: Int) -> Int {
  roll_loop(dice, sides, 0)
}

fn roll_loop(dice, sides, total) -> Int {
  case dice {
    0 -> total
    _ -> roll_loop(dice - 1, sides, total + int.random(sides) + 1)
  }
}
