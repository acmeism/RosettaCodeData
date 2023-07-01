This example shows how to use GNU APL scripting.

#!/usr/local/bin/apl --script --
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
⍝                                                                    ⍝
⍝ mazeGen.apl                          2022-01-07  19:47:35 (GMT-8)  ⍝
⍝                                                                    ⍝
 ⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝

∇initPRNG
  ⍝⍝ Seed the internal PRNG used by APL ? operator
  ⎕RL ← +/ ⎕TS   ⍝⍝ Not great... but good enough
∇

∇offs ← cellTo dir
  ⍝⍝ Return the offset (row col) to cell which lies in compass (dir)
  offs ← ∊((¯1 0)(0 1)(1 0)(0 ¯1))[('nesw'⍳dir)]
∇

∇doMaze rc
  ⍝⍝ Main function
  0 0 mazeGen rc      ⍝⍝ Do the maze gen
  m                   ⍝⍝ output result
∇

∇b ← m isVisited coord;mr;mc
  →( ∨/ (coord[1] < 1) (coord[2] < 1) )/yes
  →( ∨/ (coord > ⌊(⍴m)÷2) )/yes
  b ← ' ' ∊ m[2×coord[1];2×coord[2]]
  →0
yes:
  b←1
∇

∇c mazeGen sz ;dirs;c;dir;cell;next
  →(c≠(0 0))/gen
init:
  c ← ?sz[1],?sz[2]
  m ← mazeInit sz
gen:
  cell ← c
  dirs ← 'nesw'[4?4]
  m[2×c[1];2×c[2]] ← ' '  ⍝ mark cell as visited
dir1:
  dir ← dirs[1]
  next ← cell + cellTo dir
  →(m isVisited next)/dir2
  m ← m openWall cell dir
  next mazeGen sz
dir2:
  dir ← dirs[2]
  next ← cell + cellTo dir
  →(m isVisited next)/dir3
  m ← m openWall cell dir
  next mazeGen sz
dir3:
  dir ← dirs[3]
  next ← cell + cellTo dir
  →(m isVisited next)/dir4
  m ← m openWall cell dir
  next mazeGen sz
dir4:
  dir ← dirs[4]
  next ← cell + cellTo dir
  →(m isVisited next)/done
  m ← m openWall cell dir
  next mazeGen sz
done:
∇

∇m ← mazeInit sz;rows;cols;r
  ⍝⍝ Init an ASCII grid which
  ⍝⍝ has all closed and unvisited cells:
  ⍝⍝
  ⍝⍝  +-+
  ⍝⍝  |.|
  ⍝⍝  +-+
  ⍝⍝
  ⍝⍝ @param sz - tuple (rows cols)
  ⍝⍝ @return m - ASCII representation of (rows × cols) closed maze cells
  ⍝⍝⍝⍝

  initPRNG
  (rows cols) ← sz
  r ← ∊ (cols ⍴ ⊂"+-" ),"+"
  r ← r,∊ (cols ⍴ ⊂"|." ),"|"
  r ← (rows,(⍴r))⍴r
  r ← ((2×rows),(1+2×cols))⍴r
  r ← r⍪ (∊ (cols ⍴ ⊂"+-" ),"+")
  m ← r
∇

∇r ← m openWall cellAndDir ;ri;ci;rw;cw;row;col;dir
  (row col dir) ← ∊cellAndDir
  ri ← 2×row
  ci ← 2×col
  (rw cw) ← (ri ci) + cellTo dir
  m[rw;cw] ← ' '   ⍝ open wall in (dir)
  r ← m
∇

⎕IO←1

doMaze 9 9
)OFF
