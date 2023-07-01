#!/usr/bin/env golosh
----
This module encrypts strings by rotating each character by 13.
----
module Rot13

augment java.lang.Character {

  function rot13 = |this| -> match {
    when this >= 'a' and this <= 'z' then charValue((this - 'a' + 13) % 26 + 'a')
    when this >= 'A' and this <= 'Z' then charValue((this - 'A' + 13) % 26 + 'A')
    otherwise this
  }
}

augment java.lang.String {

  function rot13 = |this| -> vector[this: charAt(i): rot13() foreach i in [0..this: length()]]: join("")
}

function main = |args| {

  require('A': rot13() == 'N', "A is not N")
  require("n": rot13() == "a", "n is not a")
  require("nowhere ABJURER": rot13() == "abjurer NOWHERE", "nowhere is not abjurer")

  foreach string in args {
    print(string: rot13())
    print(" ")
  }
  println("")
}
