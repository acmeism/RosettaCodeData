import gleam/option.{type Option, None, Some}

/// Stack(a) is just an alias for a List(a)
pub type Stack(a) =
  List(a)

/// An empty stack is an empty list.
pub const empty = []

/// is_empty(s) checks if the stack s is empty.
pub fn is_empty(stack: Stack(a)) -> Bool {
  case stack {
    [] -> True
    _ -> False
  }
}

/// push(s,x) pushes the element x onto the stack s.
pub fn push(stack: Stack(a), x: a) -> Stack(a) {
  [x, ..stack]
}

/// peek(s) returns the TOS.
pub fn peek(stack: Stack(a)) -> Result(a, Nil) {
  case stack {
    [] -> Error(Nil)
    [h, ..] -> Ok(h)
  }
}

/// pop(s) pops an element from the TOS, and returns that
/// and the modified stack.
pub fn pop(stack: Stack(a)) -> Result(#(a, Stack(a)), Nil) {
  case stack {
    [h, ..tl] -> Ok(#(h, tl))
    _ -> Error(Nil)
  }
}
