type
  MyInt = range[1..10]

var x: MyInt = 5

x = x + 6  # Runtime error: unhandled exception: value out of range: 11 notin 1 .. 10 [RangeDefect]

x = 12     # Compile-time error: conversion from int literal(12) to MyInt is invalid
