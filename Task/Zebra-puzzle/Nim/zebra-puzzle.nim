import algorithm, strformat, sequtils

type

  Color {.pure.} = enum Blue, Green, Red, White, Yellow
  Person {.pure.} = enum Dane, English, German, Norwegian, Swede
  Pet {.pure.} = enum Birds, Cats, Dog, Horse, Zebra
  Drink {.pure.} = enum Beer, Coffee, Milk, Tea, Water
  Cigarettes {.pure.} = enum Blend, BlueMaster = "Blue Master",
                             Dunhill, PallMall = "Pall Mall", Prince

  House = tuple
    color: Color
    person: Person
    pet: Pet
    drink: Drink
    cigarettes: Cigarettes

  Houses = array[5, House]


iterator permutations[T](): array[5, T] =
  ## Yield the successive permutations of values of type T.
  var term = [T(0), T(1), T(2), T(3), T(4)]
  yield term
  while term.nextPermutation():
    yield term


proc findSolutions(): seq[Houses] =
  ## Return all the solutions.

  for colors in permutations[Color]():
    if colors.find(White) != colors.find(Green) + 1: continue                   #  5
    for persons in permutations[Person]():
      if persons[0] != Norwegian: continue                                      # 10
      if colors.find(Red) != persons.find(English): continue                    #  2
      if abs(persons.find(Norwegian) - colors.find(Blue)) != 1: continue        # 15
      for pets in permutations[Pet]():
        if persons.find(Swede) != pets.find(Dog): continue                      #  3
        for drinks in permutations[Drink]():
          if drinks[2] != Milk: continue                                        #  9
          if persons.find(Dane) != drinks.find(Tea): continue                   #  4
          if colors.find(Green) != drinks.find(Coffee): continue                #  6
          for cigarettes in permutations[Cigarettes]():
            if cigarettes.find(PallMall) != pets.find(Birds): continue          #  7
            if cigarettes.find(Dunhill) != colors.find(Yellow): continue        #  8
            if cigarettes.find(BlueMaster) != drinks.find(Beer): continue       # 13
            if cigarettes.find(Prince) != persons.find(German): continue        # 14
            if abs(cigarettes.find(Blend) - pets.find(Cats)) != 1: continue     # 11
            if abs(cigarettes.find(Dunhill) - pets.find(Horse)) != 1: continue  # 12
            if abs(cigarettes.find(Blend) - drinks.find(Water)) != 1: continue  # 16
            var houses: Houses
            for i in 0..4:
              houses[i] = (colors[i], persons[i], pets[i], drinks[i], cigarettes[i])
            result.add houses

let solutions = findSolutions()
echo "Number of solutions: ", solutions.len
let sol = solutions[0]
echo()

echo "Number  Color    Person      Pet     Drink    Cigarettes"
echo "——————  ——————   —————————   —————   ——————   ———————————"
for i in 0..4:
  echo &"{i + 1:3}     {sol[i].color:6}   {sol[i].person:9}   ",
       &"{sol[i].pet:5}   {sol[i].drink:6}   {sol[i].cigarettes: 11}"

let owner = sol.filterIt(it.pet == Zebra)[0].person
echo &"\nThe {owner} owns the zebra."
