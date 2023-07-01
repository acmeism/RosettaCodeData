on newGenerator(n, seed)
    script generator
        property seed : missing value
        property p1 : 10 ^ (n div 2)
        property p2 : 10 ^ n

        on getRandom()
            set seed to seed * seed div p1 mod p2
            return seed div 1
        end getRandom
    end script

    set generator's seed to seed mod (10 ^ n)
    return generator
end newGenerator

local generator, output
set generator to newGenerator(6, 675248)
set output to {}
repeat 5 times
    set end of output to generator's getRandom()
end repeat
return output
