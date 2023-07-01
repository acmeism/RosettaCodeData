package main

Fruit :: enum {
  Apple,
  Banana,
  Cherry,
}

FruitWithNumber :: enum {
  Strawberry = 0,
  Pear = 27,
}

main :: proc() {
  b := Fruit.Banana
  assert(int(b) == 1)     // Enums always have implicit values

  p := FruitWithNumber.Pear
  assert(int(p) == 27)
}
