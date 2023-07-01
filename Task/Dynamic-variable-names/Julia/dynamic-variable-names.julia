print("Insert the variable name: ")

variable   = Symbol(readline(STDIN))
expression = quote
    $variable = 42
    println("Inside quote:")
    @show $variable
end

eval(expression)

println("Outside quote:")
@show variable
println("If I named the variable x:")
@show x
