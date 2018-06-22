type
  MyInt = range[0..10]

var x: MyInt = 5

x = x + 6  # Runtime error: value out of range: 11

x = 12 # Compile-time error: conversion from int literal(12) to MyInt is invalid
