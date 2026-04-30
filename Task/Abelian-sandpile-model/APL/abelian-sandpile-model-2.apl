      ⍝ Result of collapsing '64'
      sandpile 9 middle 64
0 0 0 0 0 0 0 0 0
0 0 0 1 2 1 0 0 0
0 0 2 2 2 2 2 0 0
0 1 2 2 2 2 2 1 0
0 2 2 2 0 2 2 2 0
0 1 2 2 2 2 2 1 0
0 0 2 2 2 2 2 0 0
0 0 0 1 2 1 0 0 0
0 0 0 0 0 0 0 0 0

      ⍝ Write image of result of collapsing 22000
      'sandpile.ppm' to_ppm sandpile 121 middle 22000
