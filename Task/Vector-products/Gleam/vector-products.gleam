import gleam/float
import gleam/io

pub type Vector3 {
  Vector3(Float, Float, Float)
}

pub fn main() {
  let a = Vector3(3.0, 4.0, 5.0)
  let b = Vector3(4.0, 3.0, 5.0)
  let c = Vector3(-5.0, -12.0, -13.0)

  io.println("dot_product(a, b) = " <> dot_product(a, b) |> float.to_string)
  io.println("cross_product(a, b) = " <> cross_product(a, b) |> to_string)
  io.println(
    "scalar_triple_product(a, b) = "
    <> scalar_triple_product(a, b, c) |> float.to_string,
  )
  io.println(
    "vector_triple_product(a, b) = "
    <> vector_triple_product(a, b, c) |> to_string,
  )
}

pub fn dot_product(u: Vector3, v: Vector3) -> Float {
  let Vector3(a, b, c) = u
  let Vector3(x, y, z) = v
  a *. x +. b *. y +. c *. z
}

pub fn cross_product(u: Vector3, v: Vector3) -> Vector3 {
  let Vector3(a, b, c) = u
  let Vector3(x, y, z) = v
  Vector3(b *. z -. c *. y, c *. x -. a *. z, a *. y -. b *. x)
}

pub fn scalar_triple_product(u: Vector3, v: Vector3, w: Vector3) -> Float {
  dot_product(u, cross_product(v, w))
}

pub fn vector_triple_product(u: Vector3, v: Vector3, w: Vector3) -> Vector3 {
  cross_product(u, cross_product(v, w))
}

pub fn to_string(v: Vector3) -> String {
  let Vector3(a, b, c) = v
  "("
  <> float.to_string(a)
  <> ", "
  <> float.to_string(b)
  <> ", "
  <> float.to_string(c)
  <> ")"
}
