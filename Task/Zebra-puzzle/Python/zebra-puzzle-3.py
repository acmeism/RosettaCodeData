from itertools import permutations

class Number:elems= "One Two Three Four Five".split()
class Color: elems= "Red Green Blue White Yellow".split()
class Drink: elems= "Milk Coffee Water Beer Tea".split()
class Smoke: elems= "PallMall Dunhill Blend BlueMaster Prince".split()
class Pet:   elems= "Dog Cat Zebra Horse Bird".split()
class Nation:elems= "British Swedish Danish Norvegian German".split()

for c in (Number, Color, Drink, Smoke, Pet, Nation):
  for i, e in enumerate(c.elems):
    exec "%s.%s = %d" % (c.__name__, e, i)

def show_row(t, data):
  print "%6s: %12s%12s%12s%12s%12s" % (
    t.__name__, t.elems[data[0]],
    t.elems[data[1]], t.elems[data[2]],
    t.elems[data[3]], t.elems[data[4]])

def main():
  perms = list(permutations(range(5)))
  for number in perms:
    if number[Nation.Norvegian] == Number.One: # Constraint 10
      for color in perms:
        if color[Nation.British] == Color.Red: # Constraint 2
          if number[color.index(Color.Blue)] == Number.Two: # Constraint 15+10
            if number[color.index(Color.White)] - number[color.index(Color.Green)] == 1: # Constraint 5
              for drink in perms:
                if drink[Nation.Danish] == Drink.Tea: # Constraint 4
                  if drink[color.index(Color.Green)] == Drink.Coffee:  # Constraint 6
                    if drink[number.index(Number.Three)] == Drink.Milk: # Constraint 9
                      for smoke in perms:
                        if smoke[Nation.German] == Smoke.Prince: # Constraint 14
                          if drink[smoke.index(Smoke.BlueMaster)] == Drink.Beer: # Constraint 13
                            if smoke[color.index(Color.Yellow)] == Smoke.Dunhill: # Constraint 8
                              if number[smoke.index(Smoke.Blend)] - number[drink.index(Drink.Water)] in (1, -1): # Constraint 16
                                for pet in perms:
                                  if pet[Nation.Swedish] == Pet.Dog: # Constraint 3
                                    if pet[smoke.index(Smoke.PallMall)] == Pet.Bird: # Constraint 7
                                      if number[pet.index(Pet.Horse)] - number[smoke.index(Smoke.Dunhill)] in (1, -1): # Constraint 12
                                        if number[smoke.index(Smoke.Blend)] - number[pet.index(Pet.Cat)] in (1, -1): # Constraint 11
                                          print "Found a solution:"
                                          show_row(Nation, range(5))
                                          show_row(Number, number)
                                          show_row(Color, color)
                                          show_row(Drink, drink)
                                          show_row(Smoke, smoke)
                                          show_row(Pet, pet)
                                          print

main()
