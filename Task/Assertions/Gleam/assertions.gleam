pub fn main() {
  // There are two kinds of assertions in Gleam:
  // Bool and Let assertions.
  // Let assertions acknowledge that we know a pattern is a
  // partial pattern and doesn't cover all cases.
  // Bool assertions acknowledge that some condition holds.

  // Here we use a "let assert" to acknowledge that
  // the list has at least one element:
  let assert [_first, ..] = [1, 2, 3]

  // Here we use a "bool assert" to check some condition:
  assert 1 + 2 == 3 as "1 + 2 isn't 3?"
  // In both kinds of assertions, a message can be attached to it
  // with the "as" keyword, which gets printed when the program halts.
}
