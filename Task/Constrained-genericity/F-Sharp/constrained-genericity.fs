type ^a FoodBox                         // a generic type FoodBox
  when ^a: (member eat: unit -> string) // with an explicit member constraint on ^a,
  (items:^a list) =                     // a one-argument constructor
  member inline x.foodItems = items     // and a public read-only property

// a class type that fullfills the member constraint
type Banana() =
  member x.eat() = "I'm eating a banana."

// an instance of a Banana FoodBox
let someBananas = FoodBox [Banana(); Banana()]
