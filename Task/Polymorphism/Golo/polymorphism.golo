#!/usr/bin/env golosh
----
This module demonstrates Golo's version of polymorphism.
----
module Polymorphism

# Each struct automatically gets a constructor and also accessor and assignment methods for each field.
# For example, the constructor for Point is Point(1, 2)
# and the accessor methods are x() and y()
# and the assignment methods are x(10) and y(10).

struct Point = { x, y }
struct Circle = { x, y, r }

# Augmentations are the way to give your struct methods.
# They're like extension methods in C# or Xtend.

augment Point {

  function print = |this| { println("Point " + this: x() + " " + this: y()) }
}

augment Circle {

  function print = |this| { println("Circle " + this: x() + " " + this: y() + " " + this: r()) }
}

# You can define functions with the same name as your struct that work
# basically like constructors.

----
A contructor with no arguments that initializes all fields to 0
----
function Point = -> Point(0, 0)

----
This is the copy constructor when the argument is another point
----
function Point = |x| -> match {
  when x oftype Point.class then Point(x: x(), x: y())
  otherwise Point(x, 0)
}

----
A contructor with no arguments that initializes all fields to 0
----
function Circle = -> Circle(0, 0, 0)

----
This is the copy constructor when the argument is another circle
----
function Circle = |x| -> match {
  when x oftype Circle.class then Circle(x: x(), x: y(), x: r())
  otherwise Circle(x, 0, 0)
}

----
This one initializes the radius to zero
----
function Circle = |x, y| -> Circle(x, y, 0)


function main = |args| {
  let p = Point(10, 20)
  let c = Circle(10, 20, 30)
  let shapes = vector[
    Point(), Point(1), Point(1, 2), Point(p),
    Circle(), Circle(1), Circle(1, 2), Circle(1, 2, 3), Circle(c)
  ]
  foreach shape in shapes {
    shape: print()
  }
}
