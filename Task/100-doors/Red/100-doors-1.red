Red [
  Purpose: "100 Doors Problem (Perfect Squares)"
  Author: "Barry Arthur"
  Date: "07-Oct-2016"
]
doors: make vector! [char! 8 100]
repeat i 100 [change at doors i #"."]

repeat i 100 [
    j: i
    while [j <= 100] [
      door: at doors j
      change door either #"O" = first door [#"."] [#"O"]
      j: j + i
    ]
]

repeat i 10 [
  print copy/part at doors (i - 1 * 10 + 1) 10
]
