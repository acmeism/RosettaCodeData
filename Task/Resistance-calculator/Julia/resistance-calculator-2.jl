function rpn(arr::Vector)
    stack = Any[]
    for op in arr
        if isa(op, Function)
            arg2 = pop!(stack)
            arg1 = pop!(stack)
            push!(stack, op(arg1, arg2))
        else
            push!(stack, op)
        end
    end
    length(stack) != 1 && error("invalid RPN expression array: $arr")
    return stack[1]
end

node = rpn([R8, R10, +, R9, *, R7, +, R6, *, R5, +, R4, *, R3, +, R2, *, R1, +])
setvoltage(node, 18)
report(node)
