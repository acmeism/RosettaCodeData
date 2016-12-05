type
  Eatable = generic e
    eat(e)

  FoodBox[e: Eatable] = seq[e]

  Food = object
    name: string
    count: int

proc eat(x: int) = echo "Eating the int: ", x
proc eat(x: Food) = echo "Eating ", x.count, " ", x.name, "s"

var ints = FoodBox[int](@[1,2,3,4,5])
var fs = FoodBox[Food](@[])

fs.add Food(name: "Hamburger", count: 3)
fs.add Food(name: "Cheeseburger", count: 5)

for f in fs:
  eat(f)
