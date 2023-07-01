def addSub2(x,y) {
  [ x+y , x-y ]
}

def (sum, diff) = addSub2(50, 5)
assert sum == 55
assert diff == 45
