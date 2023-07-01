numerator =: monad define "0
    (3 * (! x: y)^6) %~ 32 * (!6x*y) * (y*(126 + 532*y)) + 9x
)

term =: numerator % 10x ^ 3 + 6&*

echo 'The first 10 numerators are:'
echo ,. numerator i.10

echo ''
echo 'The sum of the first 10 terms (pi^-2) is ', 0j15 ": +/ term i.10

heron =: [: -: ] + %

sqrt =: dyad define NB. usage: x0 tolerance sqrt x
                    NB. e.g.: (1, %10^100x) sqrt 2 -> √2 to 100 decimals as a ratio p/q
    x0  =. }: x
    eps =. }. x
    x1  =. y heron x0
    while. (| x1 - x0) > eps do.
        x2 =. y heron x1
        x0 =. x1
        x1 =. x2
    end.
    x1
)

pi70 =. (355r113, %10^70x) sqrt % +/ term i.53
echo ''
echo 'pi to 70 decimals: ', 0j70 ": pi70
exit ''
