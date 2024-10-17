function parseinfix2rpn(s)
    outputq = []
    opstack = []
    infix = split(s)
    for tok in infix
        if all(isnumber, tok)
            push!(outputq, tok)
        elseif tok == "("
            push!(opstack, tok)
        elseif tok == ")"
            while !isempty(opstack) && (op = pop!(opstack)) != "("
               push!(outputq, op)
            end
        else # operator
            while !isempty(opstack)
                op = pop!(opstack)
                if Base.operator_precedence(Symbol(op)) > Base.operator_precedence(Symbol(tok)) ||
                   (Base.operator_precedence(Symbol(op)) ==
                     Base.operator_precedence(Symbol(tok)) && op != "^")
                    push!(outputq, op)
                else
                    push!(opstack, op)  # undo peek
                    break
                end
            end
            push!(opstack, tok)
        end
        println("The working output stack is $outputq")
    end
    while !isempty(opstack)
        if (op = pop!(opstack)) == "("
            throw("mismatched parentheses")
        else
            push!(outputq, op)
        end
    end
    outputq
end

teststring = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
println("\nResult: $teststring becomes $(join(parseinfix2rpn(teststring), ' '))")
