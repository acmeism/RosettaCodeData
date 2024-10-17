macro evalwithx(expr, a, b)
    return quote
        x = $a
        tmp = $expr
        x = $b
        return $expr - tmp
    end
end

@evalwithx(2 ^ x, 3, 5)     # raw expression (AST)
