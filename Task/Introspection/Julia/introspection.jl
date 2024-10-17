@show VERSION
VERSION < v"0.4" && exit(1)

if isdefined(Base, :bloop) && !isempty(methods(abs))
    @show abs(bloop)
end

a, b, c = 1, 2, 3
vars = filter(x -> eval(x) isa Integer, names(Main))
println("Integer variables: ", join(vars, ", "), ".")
println("Sum of integers in the global scope: ", sum(eval.(vars)), ".")
