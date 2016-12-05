map(factorCountMod2, range(1, 100))

on factorCountMod2(n)
    {n, (length of integerFactors(n)) mod 2 = 1}
end factorCountMod2
