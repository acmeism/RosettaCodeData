import gleam/io

pub fn main() {
  repeat(3, fn() { io.println("hello") })
}

pub fn repeat(times: Int, func: fn() -> Nil) -> Nil {
  case times {
    _ if times < 1 -> Nil
    _ -> {
      func()
      repeat(times - 1, func)
    }
  }
}
