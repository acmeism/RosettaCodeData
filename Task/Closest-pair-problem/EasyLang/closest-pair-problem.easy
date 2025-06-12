# bruteforce
numfmt 0 4
x[] = [ 0.654682 0.409382 0.891663 0.716629 0.477721 0.925092 0.624291 0.211332 0.293786 0.839186 ]
y[] = [ 0.925557 0.619391 0.888594 0.996200 0.946355 0.818220 0.142924 0.221507 0.691701 0.728260 ]
n = len x[]
min = 1 / 0
for i to n - 1
   for j = i + 1 to n
      dx = x[i] - x[j]
      dy = y[i] - y[j]
      dsq = dx * dx + dy * dy
      if dsq < min
         min = dsq
         mini = i
         minj = j
      .
   .
.
print "distance between (" & x[mini] & " " & y[mini] & ") and (" & x[minj] & " " & y[minj] & ") is " & sqrt min
