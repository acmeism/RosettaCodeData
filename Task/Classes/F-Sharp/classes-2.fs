open System

type Shape =
  abstract Perimeter: unit -> float
  abstract Area: unit -> float

type Circle(radius) =
  interface Shape with
    member x.Perimeter() = 2.0 * radius * Math.PI
    member x.Area() = Math.PI * radius**2.0

type Rectangle(width, height) =
  interface Shape with
    member x.Perimeter() = 2.0 * width + 2.0 * height
    member x.Area() = width * height
