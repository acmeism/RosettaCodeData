def foo(a,b,c) p [a,b,c] end

args = [1,2,3]
foo *args                       #=> [1, 2, 3]
args = [1,2]
foo(0,*args)                    #=> [0, 1, 2]
