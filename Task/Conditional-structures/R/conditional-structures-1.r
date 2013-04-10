#Single line example
 #x is assumed to be scalar
 if(x < 3) message("x is less than 3") else if(x < 5) message("x is greater than or equal to 3 but less than 5") else message("x is greater than or equal to 5")
#Block example
 if(x < 3)
 {
    x <- 3
    warning("x has been increased to 3")
 } else
 {
    y <- x^2
 }
#It is important that the else keyword appears on the same line as the closing '}' of the if block.
