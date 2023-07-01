from math import sqrt
from sugar import `=>`, `->`

type
  WriterUnit = (float, string)
  WriterBind = proc(a: WriterUnit): WriterUnit

proc bindWith(f: (x: float) -> float; log: string): WriterBind =
  result = (a: WriterUnit) => (f(a[0]), a[1] & log)

func doneWith(x: int): WriterUnit =
  (x.float, "")

var
  logRoot = sqrt.bindWith "obtained square root, "
  logAddOne = ((x: float) => x+1'f).bindWith "added 1, "
  logHalf = ((x: float) => x/2'f).bindWith "divided by 2, "

echo 5.doneWith.logRoot.logAddOne.logHalf
