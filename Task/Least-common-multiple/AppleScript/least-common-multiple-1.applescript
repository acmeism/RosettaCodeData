-- lcm :: Integral a => a -> a -> a
on lcm(x, y)
    if x = 0 or y = 0 then
        0
    else
        abs(x div (gcd(x, y)) * y)
    end if
end lcm


-- TEST
on run

    lcm(12, 18)

    --> 36
end run


-- GENERAL FUNCTIONS

-- abs :: Num a => a -> a
on abs(x)
    if x < 0 then
        -x
    else
        x
    end if
end abs

-- gcd :: Integral a => a -> a -> a
on gcd(x, y)
    script _gcd
        on lambda(a, b)
            if b = 0 then
                a
            else
                lambda(b, a mod b)
            end if
        end lambda
    end script

    _gcd's lambda(abs(x), abs(y))
end gcd
