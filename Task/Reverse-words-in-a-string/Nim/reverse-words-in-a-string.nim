import strutils

let text = """---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...

Frost Robert -----------------------"""

proc reversed*[T](a: openArray[T], first, last: int): seq[T] =
  result = newSeq[T](last - first + 1)
  var x = first
  var y = last
  while x <= last:
    result[x] = a[y]
    dec(y)
    inc(x)

proc reversed*[T](a: openArray[T]): seq[T] =
  reversed(a, 0, a.high)

for line in text.splitLines():
  echo line.split(' ').reversed().join(" ")
