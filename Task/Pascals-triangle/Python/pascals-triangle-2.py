def scan(op, seq, it):
  a = []
  result = it
  a.append(it)
  for x in seq:
    result = op(result, x)
    a.append(result)
  return a

def pascal(n):
    def nextrow(row, x):
        return [l+r for l,r in zip(row+[0,],[0,]+row)]

    return scan(nextrow, range(n-1), [1,])

for row in pascal(4):
    print(row)
