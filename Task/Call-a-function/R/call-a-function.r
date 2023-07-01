### Calling a function that requires no arguments
no_args <- function() NULL
no_args()


### Calling a function with a fixed number of arguments
fixed_args <- function(x, y) print(paste("x=", x, ", y=", y, sep=""))
fixed_args(1, 2)        # x=1, y=2
fixed_args(y=2, x=1)    # y=1, x=2


### Calling a function with optional arguments
opt_args <- function(x=1) x
opt_args()              # x=1
opt_args(3.141)         # x=3.141


### Calling a function with a variable number of arguments
var_args <- function(...) print(list(...))
var_args(1, 2, 3)
var_args(1, c(2,3))
var_args()


### Calling a function with named arguments
fixed_args(y=2, x=1)    # x=1, y=2


### Using a function in statement context
if (TRUE) no_args()


### Using a function in first-class context within an expression
print(no_args)


### Obtaining the return value of a function
return_something <- function() 1
x <- return_something()
x


### Distinguishing built-in functions and user-defined functions
# Not easily possible. See
# http://cran.r-project.org/doc/manuals/R-ints.html#g_t_002eInternal-vs-_002ePrimitive
# for details.


### Distinguishing subroutines and functions
# No such distinction.


### Stating whether arguments are passed by value or by reference
# Pass by value.


### Is partial application possible and how
# Yes, see http://rosettacode.org/wiki/Partial_function_application#R
