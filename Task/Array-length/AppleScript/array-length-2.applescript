on run

    set xs to ["alpha", "beta", "gamma", "delta", "epsilon", ¬
        "zeta", "eta", "theta", "iota", "kappa", "lambda", "mu"]

    {_length(xs), fold(xs, succ, 0), item 12 of xs, item -1 of xs}

    --> {12, 12, "mu", "mu"}

end run

-- TWO FUNCTIONAL DEFINITIONS OF LENGTH

-- 1. Recursive definition

on _length(xs)
    if xs is [] then
        0
    else
        1 + _length(rest of xs)
    end if
end _length


-- 2. fold (λx n -> 1 + n)  0

on succ(x)
    1 + x
end succ

--[a] - > (a - > b) - > b - > [b]
on fold(xs, f, startValue)
    script mf
        property lambda : f
    end script

    set v to startValue
    repeat with x in xs
        set v to mf's lambda(v, x)
    end repeat
end fold
