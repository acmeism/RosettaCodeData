#!/usr/bin/env golosh
----
This module takes a decimal integer and converts it to a Roman numeral.
----
module Romannumeralsencode

augment java.lang.Integer {

  function digits = |this| {

    var remaining = this
    let digits = vector[]
    while remaining > 0 {
      digits: prepend(remaining % 10)
      remaining = remaining / 10
    }
    return digits
  }

  ----
  123: digitsWithPowers() will return [[1, 2], [2, 1], [3, 0]]
  ----
  function digitsWithPowers = |this| -> vector[
    [ this: digits(): get(i), (this: digits(): size() - 1) - i ] for (var i = 0, i < this: digits(): size(), i = i + 1)
  ]

  function encode = |this| {

    require(this > 0, "the integer must be positive!")

    let romanPattern = |digit, powerOf10| -> match {
      when digit == 1 then i
      when digit == 2 then i + i
      when digit == 3 then i + i + i
      when digit == 4 then i + v
      when digit == 5 then v
      when digit == 6 then v + i
      when digit == 7 then v + i + i
      when digit == 8 then v + i + i + i
      when digit == 9 then i + x
      otherwise ""
    } with {
      i, v, x = [
        [ "I", "V", "X" ],
        [ "X", "L", "C" ],
        [ "C", "D", "M" ],
        [ "M", "?", "?" ]
      ]: get(powerOf10)
    }

    return vector[ romanPattern(digit, power) foreach digit, power in this: digitsWithPowers() ]: join("")
  }
}

function main = |args| {
  println("1990 == MCMXC? " + (1990: encode() == "MCMXC"))
  println("2008 == MMVIII? " + (2008: encode() == "MMVIII"))
  println("1666 == MDCLXVI? " + (1666: encode() == "MDCLXVI"))
}
