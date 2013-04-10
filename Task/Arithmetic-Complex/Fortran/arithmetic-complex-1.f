program cdemo
    complex :: a = (5,3), b = (0.5, 6.0)      ! complex initializer
    complex :: absum, abprod, aneg, ainv

    absum  = a + b
    abprod = a * b
    aneg   = -a
    ainv   = 1.0 / a
end program cdemo
