pub fn main() -> Nil {
  let a = 50
  // variables with the same name rebind to a new value.
  // Variables are immutable in Gleam and 'a' above differs from the one below
  let a = 10
  let b = a + 42

  Nil
}
