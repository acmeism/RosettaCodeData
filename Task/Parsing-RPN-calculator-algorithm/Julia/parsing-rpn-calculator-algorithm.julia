function rpn(s)
    stack = Any[]
    for op in map(eval, map(parse, split(s)))
        if isa(op, Function)
            arg2 = pop!(stack)
            arg1 = pop!(stack)
            push!(stack, op(arg1, arg2))
        else
            push!(stack, op)
        end
        println("$op: ", join(stack, ", "))
    end
    length(stack) != 1 && error("invalid RPN expression $s")
    return stack[1]
end
rpn("3 4 2 * 1 5 - 2 3 ^ ^ / +")
