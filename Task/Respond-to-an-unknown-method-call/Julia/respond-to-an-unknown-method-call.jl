function add(a, b)
   try
       a + b
   catch
       println("caught exception")
       a * b
   end
end


println(add(2, 6))
println(add(1//2, 1//2))
println(add("Hello ", "world"))
