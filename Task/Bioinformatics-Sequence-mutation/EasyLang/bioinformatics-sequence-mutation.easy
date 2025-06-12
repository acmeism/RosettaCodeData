base$[] = [ "A" "C" "T" "G" ]
global seq[] seqnx[] seqpr[] .
proc prseq .
   len cnt[] 4
   numfmt 3 0
   ind = 1
   while seqnx[ind] <> 1
      pos += 1
      ind = seqnx[ind]
      if pos mod 40 = 1 : print ""
      if pos mod 40 = 1 : write pos & ":"
      if pos mod 4 = 1 : write " "
      cnt[seq[ind]] += 1
      write base$[seq[ind]]
   .
   print ""
   print ""
   for i to 4
      print base$[i] & ":" & cnt[i]
      sum += cnt[i]
   .
   print "====="
   print "  " & sum
   print ""
.
proc init .
   seq[] = [ 0 ]
   seqnx[] = [ 2 ]
   seqpr[] = [ 0 ]
   for i = 2 to 201
      seq[] &= random 4
      seqnx[] &= i + 1
      seqpr[] &= i - 1
   .
   seqpr[1] = len seq[]
   seqnx[$] = 1
.
proc delete pos .
   nx = seqnx[pos]
   pre = seqpr[pos]
   seqnx[pre] = nx
   seqpr[nx] = pre
   last = len seq[]
   seq[pos] = seq[last]
   seqnx[pos] = seqnx[last]
   seqpr[pos] = seqpr[last]
   seqpr[seqnx[pos]] = pos
   seqnx[seqpr[pos]] = pos
   len seq[] -1
   len seqnx[] -1
   len seqpr[] -1
.
proc insert pos .
   seq[] &= random 4
   last = len seq[]
   seqnx[] &= pos
   seqpr[] &= seqpr[pos]
   seqnx[seqpr[pos]] = last
   seqpr[pos] = last
.
proc mutate .
   op = random 3
   pos = random (len seq[] - 1) + 1
   if op = 1
      seq[pos] = random 4
   elif op = 2
      insert pos
   else
      delete pos
   .
.
init
print "Original:"
prseq
for i to 10 : mutate
print "Mutated:"
prseq
