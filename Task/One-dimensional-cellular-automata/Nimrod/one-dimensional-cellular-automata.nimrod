import math
randomize()

type
  TBoolArray = array[0..30, bool] # an array that is indexed with 0..10
  TSymbols = tuple[on: char , off: char]

const
    num_turns = 20
    symbols:TSymbols = ('#',' ')

proc `==` (x:TBoolArray,y:TBoolArray): bool =
    if len(x) != len(y):
        return False
    for i in 0..(len(x)-1):
        if x[i] != y[i]:
            return False
    return True

proc count_neighbours(map:TBoolArray , tile:int):int =
    result = 0
    if tile != len(map)-1 and map[tile+1]:
        result += 1
    if tile != 0 and map[tile-1]:
        result += 1

proc print_map(map:TBoolArray, symbols:TSymbols) =
    for i in map:
        if i:
            write(stdout,symbols[0])
        else:
            write(stdout,symbols[1])
    write(stdout,"\n")

proc random_map(): TBoolArray =
    var map = [False,False,False,False,False,False,False,False,False,False,False,
                False,False,False,False,False,False,False,False,False,False,False,
                False,False,False,False,False,False,False,False,False]
    for i in 0..(len(map)-1):
        map[i] = bool(random(2))
    return map

#make the map
var map:TBoolArray
map = random_map()
print_map(map,symbols)
for i in 0..num_turns:
    var new_map = map
    for j in 0..(len(map)-1):
        if map[j]:
            if count_neighbours(map, j) == 2 or
                count_neighbours(map, j) == 0:
                new_map[j] = False
        else:
            if count_neighbours(map, j) == 2:
                new_map[j] = True
    if new_map == map:
        print_map(map,symbols)
        break
    map = new_map
    print_map(map,symbols)
