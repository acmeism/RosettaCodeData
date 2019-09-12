#!/usr/bin/env golosh
----
This module converts a Roman numeral into a decimal number.
----
module Romannumeralsdecode

augment java.lang.Character {

  function decode = |this| -> match {
    when this == 'I' then 1
    when this == 'V' then 5
    when this == 'X' then 10
    when this == 'L' then 50
    when this == 'C' then 100
    when this == 'D' then 500
    when this == 'M' then 1000
    otherwise 0
  }
}

augment java.lang.String {

  function decode = |this| {
    var accumulator = 0
    foreach i in [0..this: length()] {
      let currentChar = this: charAt(i)
      let nextChar = match {
        when i + 1 < this: length() then this: charAt(i + 1)
        otherwise null
      }
      if (currentChar: decode() < (nextChar?: decode() orIfNull 0)) {
        # if this is something like IV or IX or whatever
        accumulator = accumulator - currentChar: decode()
      } else {
        accumulator = accumulator + currentChar: decode()
      }
    }
    return accumulator
  }
}

function main = |args| {
  println("MCMXC = " + "MCMXC": decode())
  println("MMVIII = " + "MMVIII": decode())
  println("MDCLXVI = " + "MDCLXVI": decode())
}
