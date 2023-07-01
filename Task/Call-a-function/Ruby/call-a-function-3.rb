def foo(x=0, y=x, flag=true) p [x,y,flag] end

foo                             #=> [0, 0, true]
foo(1)                          #=> [1, 1, true]
foo(1,2)                        #=> [1, 2, true]
foo 1,2,false                   #=> [1, 2, false]
