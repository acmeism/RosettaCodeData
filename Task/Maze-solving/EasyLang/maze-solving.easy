size = 15
n = 2 * size + 1
f = 100 / (n - 0.5)
len m[] n * n
#
background 000
proc show_maze . .
   clear
   for i = 1 to len m[]
      if m[i] = 0
         x = (i - 1) mod n
         y = (i - 1) div n
         color 999
         move x * f - f / 2 y * f - f / 2
         rect f * 1.5 f * 1.5
      .
   .
   sleep 0.01
.
offs[] = [ 1 n -1 (-n) ]
proc m_maze pos . .
   m[pos] = 0
   show_maze
   d[] = [ 1 2 3 4 ]
   for i = 4 downto 1
      d = randint i
      dir = offs[d[d]]
      d[d] = d[i]
      if m[pos + dir] = 1 and m[pos + 2 * dir] = 1
         m[pos + dir] = 0
         m_maze pos + 2 * dir
      .
   .
.
endpos = n * n - 1
proc make_maze . .
   for i = 1 to len m[]
      m[i] = 1
   .
   for i = 1 to n
      m[i] = 2
      m[n * i] = 2
      m[n * i - n + 1] = 2
      m[n * n - n + i] = 2
   .
   h = 2 * randint 15 - n + n * 2 * randint 15
   m_maze h
   m[endpos] = 0
.
make_maze
show_maze
#
proc mark pos col . .
   x = (pos - 1) mod n
   y = (pos - 1) div n
   color col
   move x * f + f / 4 y * f + f / 4
   circle f / 3.5
.
global found .
proc solve dir0 pos . .
   if found = 1
      return
   .
   mark pos 900
   sleep 0.05
   if pos = endpos
      found = 1
      return
   .
   of = randint 4 - 1
   for h = 1 to 4
      dir = (h + of) mod1 4
      posn = pos + offs[dir]
      if dir <> dir0 and m[posn] = 0
         solve (dir + 1) mod 4 + 1 posn
         if found = 0
            mark posn 888
            sleep 0.08
         .
      .
   .
.
sleep 1
solve 0 n + 2
