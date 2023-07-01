macro inv(expr, cond)
    cond isa Expr && cond.head == :if || throw(ArgumentError("$cond is not an if expression"))
    cond.args[2] = expr
    return cond
end

@inv println("Wow! Lucky Guess!") if true else println("Not!") end
