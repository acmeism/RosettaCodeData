say multiply(123456789,987654321)
say multiply_long(123456789,987654321)
::routine multiply
    use arg x, y
    return x *y
::routine multiply_long
    use arg x, y
    Numeric Digits (length(x)+length(y))
    return x *y
