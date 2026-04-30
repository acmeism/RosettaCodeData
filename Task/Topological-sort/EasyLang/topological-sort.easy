global name$[] g[][] .
func n2id n$ .
   for id to len name$[] : if name$[id] = n$ : return id
   name$[] &= n$
   return id
.
proc init .
   repeat
      s$ = input
      until s$ = ""
      a$[] = strtok s$ " "
      left = n2id a$[1]
      if left > len g[][] : len g[][] left
      for i = 2 to len a$[]
         id = n2id a$[i]
         if id <> left
            g[left][] &= id
         .
      .
   .
.
init
#
lng = len g[][]
len perm[] lng
len temp[] lng
global cycle result[] .
#
proc visit n .
   if perm[n] = 1 : return
   if temp[n] = 1
      cycle = 1
      return
   .
   temp[n] = 1
   for m in g[n][] : visit m
   perm[n] = 1
   result[] &= n
.
repeat
   for i to lng
      if perm[i] = 0 : break 1
   .
   until i > lng
   visit i
.
if cycle = 1
   print "un-orderable"
else
   for r in result[] : print name$[r]
.
#
input_data
des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee
dw01             ieee dw01 dware gtech
dw02             ieee dw02 dware
dw03             std synopsys dware dw03 dw02 dw01 ieee gtech
dw04             dw04 ieee dw01 dware gtech
dw05             dw05 ieee dware
dw06             dw06 ieee dware
dw07             ieee dware
dware            ieee dware
gtech            ieee gtech
ramlib           std ieee
std_cell_lib     ieee std_cell_lib
synopsys
