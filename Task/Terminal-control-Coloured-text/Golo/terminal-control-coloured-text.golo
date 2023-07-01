#!/usr/bin/env golosh
----
This module demonstrates terminal colours.
----
module Terminalcontrolcoloredtext

import gololang.AnsiCodes

function main = |args| {

  # these are lists of pointers to the ansi functions in the golo library.
  # {} doesn't do anything so it's got no effect on the text.

  let foregrounds = vector[
    ^fg_red, ^fg_blue, ^fg_magenta, ^fg_white, ^fg_black, ^fg_cyan, ^fg_green, ^fg_yellow
  ]
  let backgrounds = vector[
    ^bg_red, ^bg_blue, ^bg_magenta, ^bg_white, ^bg_black, ^bg_cyan, ^bg_green, ^bg_yellow
  ]
  let effects = vector[
    {}, ^bold, ^blink, ^underscore, ^concealed, ^reverse_video
  ]

  println("Terminal supports ansi code: " + likelySupported())

  foreach fg in foregrounds {
    foreach bg in backgrounds {
      foreach effect in effects {
        fg()
        bg()
        effect()
        print("Rosetta Code")
        reset()
      }
    }
  }
  println("")
}
