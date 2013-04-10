# Character input
 calories <- function(food) switch(food, apple=47, pizza=1500, stop("food not known"))
 calories("apple")  # 47
 calories("banana") # throws an error
# Numeric input
 alphabet <- function(number) switch(number, "a", "ab", "abc")
 alphabet(0) # null response
 alphabet(1) # "a"
 alphabet(2) # "ab"
 alphabet(3) # "abc"
 alphabet(4) # null response
# Note that no 'otherwise' option is allowed when the input is numeric.
