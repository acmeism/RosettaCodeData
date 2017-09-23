# Note functions and subroutines are called procedures (or PROCs) in Algol 68 #
# A function called without arguments: #
f;
# Algol 68 does not expect an empty parameter list for calls with no arguments, "f()" is a syntax error #
# A function with a fixed number of arguments: #
f(1, x);

# variable number of arguments: #
# functions that accept an array as a parameter can effectively provide variable numbers of arguments #
# a "literal array" (called a row-display in Algol 68) can be passed, as is often the case for the I/O #
# functions - e.g.: #
print( ( "the result is: ", r, " after ", n, " iterations", newline ) );
# the outer brackets indicate the parameters of print, the inner brackets indicates the contents are a "literal array" #

# ALGOL 68 does not support optional arguments, though in some cases an empty array could be passed to a function #
# expecting an array, e.g.: #
f( () );

# named arguments - see the Algol 68 sample in: http://rosettacode.org/wiki/Named_parameters #

# In "Talk:Call a function" a statement context is explained as
"The function is used as an instruction (with a void context),
rather than used within an expression."
Based on that, the examples above are already in a statement context.
Technically, when a function that returns other than VOID (i.e. is not a subroutine)
is called in a statement context, the result of the call is "voided" i.e. discarded.
If desired, this can be made explicit using a cast, e.g.: #
VOID(f);

# A function's return value being used: #
x := f(y);

# There is no distinction between built-in functions and user-defined functions. #

# A subroutine is simply a function that returns VOID. #

# If the function is declared with argument(s) of mode REF MODE,
then those arguments are being passed by reference. #
# Technically, all parameters are passed by value, however the value of a REF MODE is a reference... #
