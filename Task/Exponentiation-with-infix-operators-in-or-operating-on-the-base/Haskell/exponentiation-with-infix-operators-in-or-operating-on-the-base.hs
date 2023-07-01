--https://wiki.haskell.org/Power_function
main = do
    print [-5^2,-(5)^2,(-5)^2,-(5^2)] --Integer
    print [-5^^2,-(5)^^2,(-5)^^2,-(5^^2)] --Fractional
    print [-5**2,-(5)**2,(-5)**2,-(5**2)] --Real
    print [-5^3,-(5)^3,(-5)^3,-(5^3)] --Integer
    print [-5^^3,-(5)^^3,(-5)^^3,-(5^^3)] --Fractional
    print [-5**3,-(5)**3,(-5)**3,-(5**3)] --Real
