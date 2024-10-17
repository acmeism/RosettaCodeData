 julia> function foo(n)
             x = 0
             for i = 1:n
                 local x # introduce a loop-local x
                 x = i
             end
             x
         end
  foo (generic function with 1 method)

 julia> foo(10)
  0
