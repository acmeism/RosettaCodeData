on isPerfect(n)
    if (n > 1.37438691328E+11) then return missing value -- Too high for perfection to be determinable.
    return (n is in {6, 28, 496, 8128, 33550336, 8.589869056E+9, 1.37438691328E+11})
end isPerfect
