program funcDemo
    use elemFunc

    real :: a = 20.0, b = 30.0, c
    real, dimension(5) :: x = (/ 1.0, 2.0, 3.0, 4.0, 5.0 /), y = (/ 32.0, 16.0, 8.0, 4.0, 2.0 /), z

    c = multiply(a,b)     ! works with either function definition above

    z = multiply(x,y)     ! element-wise invocation only works with elemental function
end program funcDemo
