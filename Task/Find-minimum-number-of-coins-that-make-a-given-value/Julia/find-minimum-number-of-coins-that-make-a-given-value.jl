using JuMP, GLPK

model = Model(GLPK.Optimizer)
@variable(model, ones, Int)
@variable(model, twos, Int)
@variable(model, fives, Int)
@variable(model, tens, Int)
@variable(model, twenties, Int)
@variable(model, fifties, Int)
@variable(model, onehundreds, Int)
@variable(model, twohundreds, Int)
@constraint(model, ones >= 0)
@constraint(model, twos >= 0)
@constraint(model, fives >= 0)
@constraint(model, tens >= 0)
@constraint(model, twenties >= 0)
@constraint(model, fifties >= 0)
@constraint(model, onehundreds >= 0)
@constraint(model, twohundreds >= 0)
@constraint(model, 988 == 1ones +2twos + 5fives + 10tens + 20twenties + 50fifties + 100onehundreds + 200twohundreds)

@objective(model, Min, ones + twos + fives + tens + twenties + fifties + onehundreds + twohundreds)

optimize!(model)
println("Optimized total coins: ", objective_value(model))
for val in [ones, twos, fives, tens, twenties, fifties, onehundreds, twohundreds]
    println("Value of ", string(val), " is ", value(val))
end
