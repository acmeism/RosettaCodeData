list = [{:a,1},{:b,2}]          #=> [a: 1, b: 2]
list == [a: 1, b: 2]            #=> true
list[:a]                        #=> 1
list ++ [c: 3, a: 5]            #=> [a: 1, b: 2, c: 3, a: 5]
