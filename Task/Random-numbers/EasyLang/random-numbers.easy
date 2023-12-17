numfmt 5 0
e = 2.7182818284590452354
for i = 1 to 1000
   a[] &= 1 + 0.5 * sqrt (-2 * log10 randomf / log10 e) * cos (360 * randomf)
.
for v in a[]
   avg += v / len a[]
.
print "Average: " & avg
for v in a[]
   s += pow (v - avg) 2
.
s = sqrt (s / len a[])
print "Std deviation: " & s
