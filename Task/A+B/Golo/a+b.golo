#!/usr/bin/env golosh
----
This module asks for two numbers, adds them, and prints the result.
----
module Aplusb

import gololang.IO

function main = |args| {

  let line = readln("Please enter two numbers (just leave a space in between them) ")
  let numbers = line: split("[ ]+"): asList()

  require(numbers: size() == 2, "we need two numbers")

  try {

    let a, b = numbers: map(|i| -> i: toInt())

    require(a >= -1000 and a <= 1000 and b >= -1000 and b <= 1000, "both numbers need to be between -1000 and 1000")

    println(a + b)

  } catch (e) {
    println("they both need to be numbers for this to work")
  }
}
