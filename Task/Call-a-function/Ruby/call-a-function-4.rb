def foo(*args) p args end

foo                             #=> []
foo(1,2,3,4,5)                  #=> [1, 2, 3, 4, 5]
