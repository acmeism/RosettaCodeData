# A function without arguments: #
f();
# or #
f;

# A function with a fixed number of arguments: #
f(1, x);

# ALGOL 68 does not support optional arguments, variable numbers of arguments, or named
arguments.
However, some functions may take an argument "0" as an instruction to use the default value
(sort of a pseudo-optional argument). #

# In "Talk:Call a function" a statement context is explained as
"The function is used as an instruction (with a void context),
rather than used within an expression." Based on that,
both ALGOL examples above are already in a statement context.
For full ALGOL compatibility, though, they should be in the form "VOID (f ());" #

# A function's return value being used: #
x := f(y);

# There is no distinction between built-in functions and user-defined functions. #

# A subroutine is simply a function that returns VOID. #

# If the function is declared with argument(s) of mode REF MODE,
then those arguments are being passed by reference. #
