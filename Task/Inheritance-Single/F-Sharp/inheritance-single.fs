type Animal() =
  class  // explicit syntax needed for empty class
  end

type Dog() =
  inherit Animal()

type Lab() =
  inherit Dog()

type Collie() =
  inherit Dog()

type Cat() =
  inherit Animal()
