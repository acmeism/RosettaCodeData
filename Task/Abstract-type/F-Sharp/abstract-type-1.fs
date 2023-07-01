type Shape =
  abstract Perimeter: unit -> float
  abstract Area: unit -> float

type Rectangle(width, height) =
  interface Shape with
    member x.Perimeter() = 2.0 * width + 2.0 * height
    member x.Area() = width * height
