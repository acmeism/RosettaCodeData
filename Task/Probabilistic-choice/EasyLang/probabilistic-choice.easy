name$[] = [ "aleph " "beth  " "gimel " "daleth" "he    " "waw   " "zayin " "heth  " ]
probs[] = [ 1 / 5 1 / 6 1 / 7 1 / 8 1 / 9 1 / 10 1 / 11 0 ]
for i = 1 to 7
   cum += probs[i]
   cum[] &= cum
.
cum[] &= 1
probs[8] = 1 - cum[7]
len act[] 8
n = 1000000
for i to n
   h = randomf
   j = 1
   while h > cum[j]
      j += 1
   .
   act[j] += 1
.
print "Name   Ratio Expected"
print "---------------------"
numfmt 6 4
for i to 8
   print name$[i] & " " & act[i] / n & "  " & probs[i]
.
