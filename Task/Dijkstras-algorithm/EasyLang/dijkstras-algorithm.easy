global con[][] n .
proc read . .
   repeat
      s$ = input
      until s$ = ""
      a = (strcode substr s$ 1 1) - 96
      b = (strcode substr s$ 3 1) - 96
      d = number substr s$ 5 9
      if a > len con[][]
         len con[][] a
      .
      con[a][] &= b
      con[a][] &= d
   .
   con[][] &= [ ]
   n = len con[][]
.
read
#
len cost[] n
len prev[] n
#
proc dijkstra . .
   for i = 2 to len cost[]
      cost[i] = 1 / 0
   .
   len todo[] n
   todo[1] = 1
   repeat
      min = 1 / 0
      a = 0
      for i to len todo[]
         if todo[i] = 1 and cost[i] < min
            min = cost[i]
            a = i
         .
      .
      until a = 0
      todo[a] = 0
      for i = 1 step 2 to len con[a][] - 1
         b = con[a][i]
         c = con[a][i + 1]
         if cost[a] + c < cost[b]
            cost[b] = cost[a] + c
            prev[b] = a
            todo[b] = 1
         .
      .
   .
.
dijkstra
#
func$ gpath nd$ .
   nd = strcode nd$ - 96
   while nd <> 1
      s$ = " -> " & strchar (nd + 96) & s$
      nd = prev[nd]
   .
   return "a" & s$
.
print gpath "e"
print gpath "f"
#
input_data
a b 7
a c 9
a f 14
b c 10
b d 15
c d 11
c f 2
d e 6
e f 9
