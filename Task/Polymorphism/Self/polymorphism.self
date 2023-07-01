traits point = (|
  parent* = traits clonable.
  printString = ('Point(', x asString, ':', y asString, ')').
  |)

point = (|
  parent* = traits point.
  x <- 0.
  y <- 0
  |)

traits circle = (|
  parent* = traits clonable.
  printString = ('Circle(', center asString, ',', r asString, ')').
  |)

circle = (|
  parent* = traits circle.
  center <- point copy.
  r <- 0
  |)
