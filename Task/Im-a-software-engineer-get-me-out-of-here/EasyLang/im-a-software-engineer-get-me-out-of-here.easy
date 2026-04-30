s$ = input
nc = len s$
while s$ <> ""
   nr += 1
   for c$ in strchars s$ : m[] &= number c$
   s$ = input
.
n = len m[]
#
func inside p m d .
   dy[] = [ -1 -1 0 1 1 1 0 -1 ]
   dx[] = [ 0 1 1 1 0 -1 -1 -1 ]
   py = p div nc + m * dy[d]
   px = p mod nc - 1 + m * dx[d]
   if px < 0 or py < 0 : return 0
   if px >= nc or py >= nr : return 0
   return 1
.
#
dir[] = [ -nc (-nc + 1) 1 (nc + 1) nc (nc - 1) -1 (-nc - 1) ]
#
proc showway &seen[] p start .
   h[] = [ ]
   repeat
      h[] &= p
      p = seen[p]
      until p = start
   .
   write start div nc & ":" & start mod nc - 1
   for j = len h[] downto 1
      write " -> " & h[j] div nc & ":" & h[j] mod nc - 1
   .
   print ""
.
proc route start dest .
   len seen[] n
   todo[] = [ start ]
   seen[start] = 1
   #
   shortest = 999
   while len todo[] > 0 and cnt <= shortest
      for p in todo[]
         m = m[p]
         if p = dest or dest = -1 and m = 0
            if shortest = 999 : shortest = cnt
            nshortest += 1
            showway seen[] p start
         else
            for j to 8 : if inside p m j = 1
               pn = p + m * dir[j]
               if m[pn] >= 0 and seen[pn] = 0
                  todon[] &= pn
                  seen[pn] = p
               .
            .
         .
      .
      swap todo[] todon[]
      todon[] = [ ]
      cnt += 1
   .
   if dest = -1
      write nshortest & " different safe points can be reached with " & shortest & " steps"
      print " (only one possible route is displayed in each case)"
   .
   print ""
.
print "Shortest ways to safe points:"
route 11 * nc + 11 + 1, -1
#
print "One of the shortest routes between 21/11 and 1/11:"
route 21 * nc + 11 + 1, 1 * nc + 11 + 1
print "One of the shortest routes between 1/11 and 21/11:"
route 1 * nc + 11 + 1, 21 * nc + 11 + 1
#
global con[][] .
#
proc floydwarshall .
   con[][] = [ ]
   for i to n
      con[][] &= [ ]
      for j to n : con[i][] &= 1 / 0
   .
   for p to len m[]
      m = m[p]
      if m > 0
         for i to 8 : if inside p m i = 1
            pn = p + m * dir[i]
            if m[pn] >= 0 : con[p][pn] = 1
         .
      .
   .
   for k to n : for i to n : for j to n
      con[i][j] = lower con[i][j] (con[i][k] + con[k][j])
   .
.
floydwarshall
#
for i to n : for j to n
   if con[i][j] <> 1 / 0 and con[i][j] >= max
      max = con[i][j]
   .
.
print "The longest shortest routes between any to points is " & max
print "These points can be connected with this distance:"
for i to n : for j to n
   if con[i][j] = max : route i j
.
#
input_data
.........00000.........
......00003130000......
....000321322221000....
...00231222432132200...
..0041433223233211100..
..0232231612142618530..
.003152122326114121200.
.031252235216111132210.
.022211246332311115210.
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
.013322444412122123210.
.015132331312411123120.
.003333612214233913300.
..0219126511415312570..
..0021321524341325100..
...00211415413523200...
....000122111322000....
......00001120000......
.........00000.........
