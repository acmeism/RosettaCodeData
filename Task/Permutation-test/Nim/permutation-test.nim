import strformat

const data = [85, 88, 75, 66, 25,
              29, 83, 39, 97, 68,
              41, 10, 49, 16, 65,
              32, 92, 28, 98]

func pick(at, remain, accu, treat: int): int =
  if remain == 0:
    return if accu > treat: 1 else: 0
  return pick(at - 1, remain - 1, accu + data[at - 1], treat) +
    (if at > remain: pick(at - 1, remain, accu, treat) else: 0)


var treat = 0
var le, gt = 0
var total = 1.0
for i in countup(0, 8):
  treat += data[i]
for i in countdown(19, 11):
  total *= float(i)
for i in countdown(9, 1):
  total /= float(i)

gt = pick(19, 9, 0, treat)
le = int(total - float(gt))
echo fmt"<= : {100.0 * float(le) / total:.6f}% {le}"
echo fmt" > : {100.0 * float(gt) / total:.6f}% {gt}"
