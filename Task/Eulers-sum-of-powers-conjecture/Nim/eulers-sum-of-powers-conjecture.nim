# Brute force approach

import times

# assumes an array of non-decreasing positive integers
proc binarySearch(a : openArray[int], target : int) : int =
  var left, right, mid : int
  left = 0
  right = len(a) - 1
  while true :
    if left > right : return 0  # no match found
    mid = (left + right) div 2
    if a[mid] < target :
      left = mid + 1
    elif a[mid] > target :
      right = mid - 1
    else :
      return mid  # match found

var
  p5 : array[250, int]
  sum = 0
  y, t1 : int

let t0 = cpuTime()

for i in 1 .. 249 :
  p5[i] = i * i * i * i * i

for x0 in 1 .. 249 :
  for x1 in 1 .. x0 - 1 :
    for x2 in 1 .. x1 - 1 :
      for x3 in 1 .. x2 - 1 :
        sum = p5[x0] + p5[x1] + p5[x2] + p5[x3]
        y = binarySearch(p5, sum)
        if y > 0 :
          t1 = int((cputime() - t0) * 1000.0)
          echo "Time : ", t1, " milliseconds"
          echo  $x0 & "^5 + " & $x1 & "^5 + " & $x2 & "^5 + " & $x3 & "^5 = " & $y & "^5"
          quit()

if y == 0 :
  echo "No solution was found"
