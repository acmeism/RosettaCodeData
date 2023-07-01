import algorithm
import random
import sequtils
import times


####################################################################################################
# Data.

proc oneSeq(n: int): seq[int] = repeat(1, n)

#---------------------------------------------------------------------------------------------------

proc shuffledSeq(n: int): seq[int] =
  result.setLen(n)
  for item in result.mitems: item = rand(1..(10 * n))

#---------------------------------------------------------------------------------------------------

proc ascendingSeq(n: int): seq[int] = sorted(shuffledSeq(n))


####################################################################################################
# Algorithms.

func bubbleSort(a: var openArray[int]) {.locks: "unknown".} =
  var n = a.len
  while true:
    var n2 = 0
    for i in 1..<n:
      if a[i - 1] > a[i]:
        swap a[i], a[i - 1]
        n2 = i
    n = n2
    if n == 0: break

#---------------------------------------------------------------------------------------------------

func insertionSort(a: var openArray[int]) {.locks: "unknown".} =
  for index in 1..a.high:
    let value = a[index]
    var subIndex = index - 1
    while subIndex >= 0 and a[subIndex] > value:
      a[subIndex + 1] = a[subIndex]
      dec subIndex
    a[subIndex + 1] = value

#---------------------------------------------------------------------------------------------------

func quickSort(a: var openArray[int]) {.locks: "unknown".} =

  func sorter(a: var openArray[int]; first, last: int) =
    if last - first < 1: return
    let pivot = a[first + (last - first) div 2]
    var left = first
    var right = last
    while left <= right:
      while a[left] < pivot: inc left
      while a[right] > pivot: dec right
      if left <= right:
        swap a[left], a[right]
        inc left
        dec right
    if first < right: a.sorter(first, right)
    if left < last: a.sorter(left, last)

  a.sorter(0, a.high)

#---------------------------------------------------------------------------------------------------

func radixSort(a: var openArray[int]) {.locks: "unknown".} =

  var tmp = newSeq[int](a.len)

  for shift in countdown(63, 0):
    for item in tmp.mitems: item = 0
    var j = 0
    for i in 0..a.high:
      let move = a[i] shl shift >= 0
      let toBeMoved = if shift == 0: not move else: move
      if toBeMoved:
        tmp[j] = a[i]
        inc j
      else:
        a[i - j] = a[i]
    for i in j..tmp.high: tmp[i] = a[i - j]
    for i in 0..a.high: a[i] = tmp[i]

#---------------------------------------------------------------------------------------------------

func shellSort(a: var openArray[int]) {.locks: "unknown".} =

  const Gaps = [701, 301, 132, 57, 23, 10, 4, 1]

  for gap in Gaps:
    for i in gap..a.high:
      let temp = a[i]
      var j = i
      while j >= gap and a[j - gap] > temp:
        a[j] = a[j - gap]
        dec j, gap
      a[j] = temp

#---------------------------------------------------------------------------------------------------

func standardSort(a: var openArray[int]) =
  a.sort()


####################################################################################################
# Main code.

import strformat

const

  Runs = 10
  Lengths = [1, 10, 100, 1_000, 10_000, 100_000]

  Sorts = [bubbleSort, insertionSort, quickSort, radixSort, shellSort, standardSort]

const
  SortTitles = ["Bubble", "Insert", "Quick ", "Radix ", "Shell ", "Standard"]
  SeqTitles = ["All Ones", "Ascending", "Shuffled"]

var totals: array[SeqTitles.len, array[Sorts.len, array[Lengths.len, Duration]]]

randomize()

for k, n in Lengths:
  let seqs = [oneSeq(n), ascendingSeq(n), shuffledSeq(n)]
  for _ in 1..Runs:
    for i, s in seqs:
      for j, sort in Sorts:
        var s = s
        let t0 = getTime()
        s.sort()
        totals[i][j][k] += getTime() - t0

echo "All timings in microseconds\n"
stdout.write "Sequence length  "
for length in Lengths:
  stdout.write &"{length:6d}     "
echo '\n'
for i in 0..SeqTitles.high:
  echo &"  {SeqTitles[i]}:"
  for j in 0..Sorts.high:
    stdout.write &"  {SortTitles[j]:8s}     "
    for k in 0..Lengths.high:
      let time = totals[i][j][k].inMicroseconds div Runs
      stdout.write &"{time:8d}   "
    echo ""
  echo '\n'
