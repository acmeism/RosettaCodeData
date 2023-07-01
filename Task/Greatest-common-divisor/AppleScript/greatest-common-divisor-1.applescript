-- gcd :: Int -> Int -> Int
on gcd(a, b)
    if b ≠ 0 then
        gcd(b, a mod b)
    else
        if a < 0 then
            -a
        else
            a
        end if
    end if
end gcd
