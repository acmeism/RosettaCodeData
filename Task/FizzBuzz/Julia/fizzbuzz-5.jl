for i in 1:100
    msg = "Fizz" ^ (i % 3 == 0) * "Buzz" ^ (i % 5 == 0)
    println(isempty(msg) ? i : msg)
end
