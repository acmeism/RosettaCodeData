'''
Improved version: Instead of simple variables (a, b),
more intelligible and readable (?) variables are employed.
'''
def doc1():
  '''
    There are five houses.
    The English man lives in the red house.
    The Swede has a dog.
    The Dane drinks tea.
    The green house is immediately to the left of the white house.
    They drink coffee in the green house.
    The man who smokes Pall Mall has a bird.
    In the yellow house they smoke Dunhill.
    In the middle house they drink milk.
    The Norwegian lives in the first house.
    The man who smokes Blend lives in the house next to the house with a cat.
    In a house next to the house where they have a horse, they smoke Dunhill.
    The man who smokes Blue Master drinks beer.
    The German smokes Prince.
    The Norwegian lives next to the blue house.
    They drink water in a house next to the house where they smoke Blend.

  The solution:

       Nation:   Norwegian        Dane  Englishman      German       Swede
        Color:      Yellow        Blue         Red       Green       White
        Smoke:     Dunhill       Blend    PallMall      Prince  BlueMaster
          Pet:         Cat       Horse        Bird       Zebra         Dog
        Drink:       Water         Tea        Milk      Coffee        Beer
  '''

import os
print(os.system('cls') if os.name  ==  'nt' else os.system('clear'))

print(doc1.__doc__)
input('<key>')

from constraint import *

p = Problem()

Nation = ['Englishman',       'Dane',  'German', 'Norwegian',  'Swede']
Color  = [      'Blue',      'Green',     'Red',     'White', 'Yellow']
Smoke  = [     'Blend', 'BlueMaster', 'Dunhill',  'PallMall', 'Prince']
Pet    = [      'Bird',        'Cat',     'Dog',     'Horse',  'Zebra']
Drink  = [      'Beer',     'Coffee',    'Milk',       'Tea',  'Water']

# add variables: house numbers 1 to 5
p.addVariables(Nation, range(1,6))
p.addVariables(Color,  range(1,6))
p.addVariables(Smoke,  range(1,6))
p.addVariables(Pet,    range(1,6))
p.addVariables(Drink,  range(1,6))

# add constraint: the values in each list are exclusive
p.addConstraint(AllDifferentConstraint(), Nation)
p.addConstraint(AllDifferentConstraint(), Color)
p.addConstraint(AllDifferentConstraint(), Smoke)
p.addConstraint(AllDifferentConstraint(), Pet)
p.addConstraint(AllDifferentConstraint(), Drink)

# add constraint: actual constraints
# The English man lives in the red house.
p.addConstraint(
  lambda house_englishman, red:
    house_englishman is red,
  ['Englishman', 'Red'])

# The Swede has a dog.
p.addConstraint(
  lambda pet_swede, dog:
    pet_swede is dog,
  ['Swede', 'Dog'])

# The Dane drinks tea.
p.addConstraint(
  lambda drink_dane, tea:
    drink_dane is tea,
  ['Dane', 'Tea'])

# The green house is immediately to the left of the white house.
p.addConstraint(
  lambda green_house, white_house:
    # Houses 1 .. 5 -> green house is 1 lower than white house
    green_house is white_house - 1,
  ['Green', 'White'])

# They drink coffee in the green house.
p.addConstraint(
  lambda drink_green_house, coffee:
    drink_green_house is coffee,
  ['Green', 'Coffee'])

# The man who smokes Pall Mall has a bird.
p.addConstraint(
  lambda pet_of_pallmall_smoker, a_bird:
    pet_of_pallmall_smoker is a_bird,
  ['PallMall', 'Bird'])

# In the yellow house they smoke Dunhill.
p.addConstraint(
  lambda owner_yellow_house, dunhill_smoker:
    owner_yellow_house is dunhill_smoker,
  ['Yellow', 'Dunhill'])

# In the middle house they drink milk.
p.addConstraint(
  lambda house_number_milk_drinker:
    house_number_milk_drinker is 3,
  ['Milk'])

# The Norwegian lives in the first house.
p.addConstraint(
  lambda house_number_norwegian:
    house_number_norwegian is 1,
  ['Norwegian'])

# The man who smokes Blend lives in the house next to the house with a cat.
p.addConstraint(
  lambda house_number_blend_smoker, number_of_house_with_cat:
    # next -> housenumber +/- 1
    house_number_blend_smoker is number_of_house_with_cat + 1 or
    house_number_blend_smoker is number_of_house_with_cat - 1,
  ['Blend', 'Cat'])

# In a house next to the house where they have a horse, they smoke Dunhill.
p.addConstraint(
  lambda house_number_dunhill_smoker, number_of_house_with_horse:
    # next -> housenumber +/- 1
    house_number_dunhill_smoker is number_of_house_with_horse + 1 or
    house_number_dunhill_smoker is number_of_house_with_horse - 1,
  ['Dunhill', 'Horse'])

# The man who smokes Blue Master drinks beer.
p.addConstraint(
  lambda drink_bluemaster_smoker, beer:
    drink_bluemaster_smoker is beer,
  ['BlueMaster', 'Beer'])

# The German smokes Prince.
p.addConstraint(
  lambda prince_smoker, german:
    prince_smoker is german,
  ['Prince', 'German'])

# The Norwegian lives next to the blue house.
p.addConstraint(
  lambda house_number_norwegian, house_number_blue_house:
    house_number_norwegian is house_number_blue_house + 1 or
    house_number_norwegian is house_number_blue_house - 1,
  ['Norwegian', 'Blue'])

# They drink water in a house next to the house where they smoke Blend.
p.addConstraint(
  lambda house_number_water_drinker, house_number_blend_smoker:
    house_number_water_drinker is house_number_blend_smoker + 1 or
    house_number_water_drinker is house_number_blend_smoker - 1,
['Water', 'Blend'])

# get solution
sol = p.getSolution()

# print the answers
nation = ['Nation' if i == 0 else ''  for i in range(6)]
color  = ['Color'  if i == 0 else ''  for i in range(6)]
smoke  = ['Smoke'  if i == 0 else ''  for i in range(6)]
pet    = ['Pet'    if i == 0 else ''  for i in range(6)]
drink  = ['Drink'  if i == 0 else ''  for i in range(6)]

for n in Nation: nation[sol[n]] = n
for n in  Color:  color[sol[n]] = n
for n in  Smoke:  smoke[sol[n]] = n
for n in    Pet:    pet[sol[n]] = n
for n in  Drink:  drink[sol[n]] = n

# put the answers in the correct order of solution
print('\n\n', 'The calculated solution:', '\n')

for r in [nation, color, smoke, pet, drink]:
  print(f'{r[0]:>13s}: ', end='')
  for i in range(1, 6):
    print(f'{r[i]:>14s}',end='')
  print()
print()
