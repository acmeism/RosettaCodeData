arr = []
p arr.inject(0, :+)               #=> 0
p arr.inject(1, :*)               #=> 1
p arr.inject(:+)                  #=> nil
p arr.inject(:*)                  #=> nil
