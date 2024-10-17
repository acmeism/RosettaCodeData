add_things = ->(x1 : Int32, x2 : Int32, x3 : Int32) { x1 + x2 + x3 }
add_curried = add_things.partial(2, 3)
add_curried.call(4)  #=> 9

def add_two_things(x1)
  return ->(x2 : Int32) {
    ->(x3 : Int32) { x1 + x2 + x3 }
  }
end
add13 = add_two_things(3).call(10)
add13.call(5)  #=> 18
