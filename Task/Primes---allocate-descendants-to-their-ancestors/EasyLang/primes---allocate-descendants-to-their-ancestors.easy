fastfunc isprim num .
   i = 2
   while i <= sqrt num
      if num mod i = 0 : return 0
      i += 1
   .
   return 1
.
proc qsort left right &d[] .
   if left < right
      piv = d[left]
      mid = left
      for i = left + 1 to right : if d[i] < piv
         mid += 1
         swap d[i] d[mid]
      .
      swap d[left] d[mid]
      qsort left mid - 1 d[]
      qsort mid + 1 right d[]
   .
.
proc sort &d[] .
   qsort 1 len d[] d[]
.
maxsum = 99
len desc[][] maxsum
len ances[][] maxsum
#
prim99[] = [ 2 ]
for i = 3 step 2 to maxsum
   if isprim i = 1 : prim99[] &= i
.
for p in prim99[]
   desc[p][] &= p
   for s = 1 to len desc[][] - p
      for ps in desc[s][]
         desc[s + p][] &= p * ps
      .
   .
.
for p in prim99[] : len desc[p][] -1
len desc[4][] -1
#
for s = 1 to maxsum
   sort desc[s][]
   total += len desc[s][]
   for d = 1 to len desc[s][]
      if desc[s][d] <= maxsum
         for p = 1 to len ances[s][]
            ances[desc[s][d]][] &= ances[s][p]
         .
         ances[desc[s][d]][] &= s
      .
   .
   if s = 10 or s = 46 or s = maxsum
      print "-- " & s & " --"
      print len ances[s][] & " Ancestors: " & ances[s][]
      write len desc[s][] & " Descendants: "
      if len desc[s][] < 10
         print desc[s][]
      else
         print "[ " & desc[s][1] & " " & desc[s][2] & " ... " & desc[s][len desc[s][]] & " ]"
      .
      print ""
   .
.
print total & " total descendants"
