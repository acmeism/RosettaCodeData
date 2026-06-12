import gleam/float
import gleam/io

pub type Quaternion {
  Quaternion(Float, Float, Float, Float)
}

pub fn main() {
  let q = Quaternion(1.0, 2.0, 3.0, 4.0)
  let q1 = Quaternion(2.0, 3.0, 4.0, 5.0)
  let q2 = Quaternion(3.0, 4.0, 5.0, 6.0)
  let r = 7.0

  io.println("q = " <> to_string(q))
  io.println("q1 = " <> to_string(q1))
  io.println("q2 = " <> to_string(q2))
  io.println("r = " <> float.to_string(r) <> "\n")

  io.println("norm(q) = " <> float.to_string(norm(q)))
  io.println("negate(q) = " <> negate(q) |> to_string())
  io.println("conjugate(q) = " <> conjugate(q) |> to_string())
  io.println("add_scalar(q, r) = " <> add_scalar(q, r) |> to_string())
  io.println("add(q1, q2) = " <> add(q1, q2) |> to_string())
  io.println("multiply_scalar(q, r) = " <> multiply_scalar(q, r) |> to_string())
  io.println("multiply(q1, q2) = " <> multiply(q1, q2) |> to_string())
  io.println("multiply(q2, q1) = " <> multiply(q2, q1) |> to_string())
}

pub fn to_string(q: Quaternion) -> String {
  let Quaternion(a, b, c, d) = q
  "("
  <> float.to_string(a)
  <> ", "
  <> float.to_string(b)
  <> ", "
  <> float.to_string(c)
  <> ", "
  <> float.to_string(d)
  <> ")"
}

pub fn norm(q: Quaternion) -> Float {
  let Quaternion(a, b, c, d) = q
  let assert Ok(result) =
    float.square_root(a *. a +. b *. b +. c *. c +. d *. d)
  result
}

pub fn negate(q: Quaternion) -> Quaternion {
  let Quaternion(a, b, c, d) = q
  Quaternion(-1.0 *. a, -1.0 *. b, -1.0 *. c, -1.0 *. d)
}

pub fn conjugate(q: Quaternion) -> Quaternion {
  let Quaternion(a, b, c, d) = q
  Quaternion(a, -1.0 *. b, -1.0 *. c, -1.0 *. d)
}

pub fn add_scalar(q: Quaternion, real: Float) -> Quaternion {
  let Quaternion(a, b, c, d) = q
  Quaternion(real +. a, b, c, d)
}

pub fn add(q1: Quaternion, q2: Quaternion) -> Quaternion {
  let Quaternion(a, b, c, d) = q1
  let Quaternion(w, x, y, z) = q2
  Quaternion(a +. w, b +. x, c +. y, d +. z)
}

pub fn multiply_scalar(q: Quaternion, real: Float) -> Quaternion {
  let Quaternion(a, b, c, d) = q
  Quaternion(a *. real, b *. real, c *. real, d *. real)
}

pub fn multiply(q1: Quaternion, q2: Quaternion) -> Quaternion {
  let Quaternion(a, b, c, d) = q1
  let Quaternion(w, x, y, z) = q2
  Quaternion(
    a *. w -. b *. x -. c *. y -. d *. z,
    a *. x +. w *. b +. c *. z -. d *. y,
    a *. y -. b *. z +. c *. w +. d *. x,
    a *. z +. b *. y -. c *. x +. d *. w,
  )
}
