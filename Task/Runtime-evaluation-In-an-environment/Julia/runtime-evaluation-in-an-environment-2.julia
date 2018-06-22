function evalwithx(expr::Expr, a, b)
    a = eval(quote let x = $a; return $expr end end)
    b = eval(quote let x = $b; return $expr end end)
    return b - a
end
evalwithx(expr::AbstractString, a, b) = evalwithx(parse(expr), a, b)

evalwithx(:(2 ^ x), 3, 5)
evalwithx("2 ^ x", 3, 5)
