import psyco; psyco.full()

class Content: elems= """Beer Coffee Milk Tea Water
                         Danish English German Norwegian Swedish
                         Blue Green Red White Yellow
                         Blend BlueMaster Dunhill PallMall Prince
                         Bird Cat Dog Horse Zebra""".split()
class Test: elems= "Drink Person Color Smoke Pet".split()
class House: elems= "One Two Three Four Five".split()

for c in (Content, Test, House):
  c.values = range(len(c.elems))
  for i, e in enumerate(c.elems):
    exec "%s.%s = %d" % (c.__name__, e, i)

def finalChecks(M):
  def diff(a, b, ca, cb):
    for h1 in House.values:
      for h2 in House.values:
        if M[ca][h1] == a and M[cb][h2] == b:
          return h1 - h2
    assert False

  return abs(diff(Content.Norwegian, Content.Blue,
                 Test.Person, Test.Color)) == 1 and \
         diff(Content.Green, Content.White,
              Test.Color, Test.Color) == -1 and \
         abs(diff(Content.Horse, Content.Dunhill,
                  Test.Pet, Test.Smoke)) == 1 and \
         abs(diff(Content.Water, Content.Blend,
                  Test.Drink, Test.Smoke)) == 1 and \
         abs(diff(Content.Blend, Content.Cat,
                  Test.Smoke, Test.Pet)) == 1

def constrained(M, atest):
      if atest == Test.Drink:
        return M[Test.Drink][House.Three] == Content.Milk
      elif atest == Test.Person:
        for h in House.values:
          if ((M[Test.Person][h] == Content.Norwegian and
               h != House.One) or
              (M[Test.Person][h] == Content.Danish and
               M[Test.Drink][h] != Content.Tea)):
            return False
        return True
      elif atest == Test.Color:
        for h in House.values:
          if ((M[Test.Person][h] == Content.English and
               M[Test.Color][h] != Content.Red) or
              (M[Test.Drink][h] == Content.Coffee and
               M[Test.Color][h] != Content.Green)):
            return False
        return True
      elif atest == Test.Smoke:
        for h in House.values:
          if ((M[Test.Color][h] == Content.Yellow and
               M[Test.Smoke][h] != Content.Dunhill) or
              (M[Test.Smoke][h] == Content.BlueMaster and
               M[Test.Drink][h] != Content.Beer) or
              (M[Test.Person][h] == Content.German and
               M[Test.Smoke][h] != Content.Prince)):
            return False
        return True
      elif atest == Test.Pet:
        for h in House.values:
          if ((M[Test.Person][h] == Content.Swedish and
               M[Test.Pet][h] != Content.Dog) or
              (M[Test.Smoke][h] == Content.PallMall and
               M[Test.Pet][h] != Content.Bird)):
            return False
        return finalChecks(M)

def show(M):
  for h in House.values:
    print "%5s:" % House.elems[h],
    for t in Test.values:
      print "%10s" % Content.elems[M[t][h]],
    print

def solve(M, t, n):
  if n == 1 and constrained(M, t):
    if t < 4:
      solve(M, Test.values[t + 1], 5)
    else:
      show(M)
      return

  for i in xrange(n):
    solve(M, t, n - 1)
    M[t][0 if n % 2 else i], M[t][n - 1] = \
      M[t][n - 1], M[t][0 if n % 2 else i]

def main():
  M = [[None] * len(Test.elems) for _ in xrange(len(House.elems))]
  for t in Test.values:
    for h in House.values:
      M[t][h] = Content.values[t * 5 + h]

  solve(M, Test.Drink, 5)

main()
