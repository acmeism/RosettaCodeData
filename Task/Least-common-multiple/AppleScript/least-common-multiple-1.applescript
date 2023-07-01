------------------ LEAST COMMON MULTIPLE -----------------

-- lcm :: Integral a => a -> a -> a
on lcm(x, y)
    if 0 = x or 0 = y then
        0
    else
        abs(x div (gcd(x, y)) * y)
    end if
end lcm


--------------------------- TEST -------------------------
on run

    lcm(12, 18)

    --> 36
end run


-------------------- GENERIC FUNCTIONS -------------------

-- abs :: Num a => a -> a
on abs(x)
    if 0 > x then
        -x
    else
        x
    end if
end abs


-- gcd :: Integral a => a -> a -> a
on gcd(x, y)
    script
        on |λ|(a, b)
            if 0 = b then
                a
            else
                |λ|(b, a mod b)
            end if
        end |λ|
    end script

    result's |λ|(abs(x), abs(y))
end gcd
