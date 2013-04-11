from itertools import permutations
import psyco
psyco.full()

class Number:elems= "One Two Three Four Five".split()
class Color: elems= "Red Green Blue White Yellow".split()
class Drink: elems= "Milk Coffee Water Beer Tea".split()
class Smoke: elems= "PallMall Dunhill Blend BlueMaster Prince".split()
class Pet:   elems= "Dog Cat Zebra Horse Bird".split()
class Nation:elems= "British Swedish Danish Norvegian German".split()

for c in (Number, Color, Drink, Smoke, Pet, Nation):
  for i, e in enumerate(c.elems):
    exec "%s.%s = %d" % (c.__name__, e, i)

def is_possible(number, color, drink, smoke, pet):
  if number and number[Nation.Norvegian] != Number.One:
    return False
  if color and color[Nation.British] != Color.Red:
    return False
  if drink and drink[Nation.Danish] != Drink.Tea:
    return False
  if smoke and smoke[Nation.German] != Smoke.Prince:
    return False
  if pet and pet[Nation.Swedish] != Pet.Dog:
    return False

  if not number or not color or not drink or not smoke or not pet:
    return True

  for i in xrange(5):
    if color[i] == Color.Green and drink[i] != Drink.Coffee:
      return False
    if smoke[i] == Smoke.PallMall and pet[i] != Pet.Bird:
      return False
    if color[i] == Color.Yellow and smoke[i] != Smoke.Dunhill:
      return False
    if number[i] == Number.Three and drink[i] != Drink.Milk:
      return False
    if smoke[i] == Smoke.BlueMaster and drink[i] != Drink.Beer:
       return False
    if color[i] == Color.Blue and number[i] != Number.Two:
      return False

    for j in xrange(5):
      if (color[i] == Color.Green and
          color[j] == Color.White and
          number[j] - number[i] != 1):
          return False

      diff = abs(number[i] - number[j])
      if smoke[i] == Smoke.Blend and pet[j] == Pet.Cat and diff != 1:
        return False
      if pet[i]==Pet.Horse and smoke[j]==Smoke.Dunhill and diff != 1:
        return False
      if smoke[i]==Smoke.Blend and drink[j]==Drink.Water and diff!=1:
        return False

  return True

def show_row(t, data):
  print "%6s: %12s%12s%12s%12s%12s" % (
    t.__name__, t.elems[data[0]],
    t.elems[data[1]], t.elems[data[2]],
    t.elems[data[3]], t.elems[data[4]])

def main():
  perms = list(permutations(range(5)))

  for number in perms:
    if is_possible(number, None, None, None, None):
      for color in perms:
        if is_possible(number, color, None, None, None):
          for drink in perms:
            if is_possible(number, color, drink, None, None):
              for smoke in perms:
                if is_possible(number, color, drink, smoke, None):
                  for pet in perms:
                    if is_possible(number, color, drink, smoke, pet):
                      print "Found a solution:"
                      show_row(Nation, range(5))
                      show_row(Number, number)
                      show_row(Color, color)
                      show_row(Drink, drink)
                      show_row(Smoke, smoke)
                      show_row(Pet, pet)
                      print

main()
