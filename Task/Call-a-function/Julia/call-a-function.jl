#  Calling a function that requires no arguments:
f() = print("Hello world!")
f()


#  Calling a function with a fixed number of arguments:
function f(x, y, z)
    x*y - z^2
end

f(3, 4, 2)


#  Calling a function with optional arguments:
#  Note Julia uses multiple dispatch based on argument number and type, so
# f() is always different from f(x) unless default arguments are used, as in:

pimultiple(mult=1.0) = pi * mult # so pimultiple() defaults to pi * (1.0) or pi


#  Calling a function with a variable number of arguments:

f(a,b,x...) = reduce(+, 0, x) - a - b


# here a and b are single arguments, but x is a tuple of x plus whatever follows x, so:
a = b = c = d = e = 3
f(a,b,c)           # x within the function is (c) so == 0 + c - a - b
f(a,b,c,d,e)      # x is a tuple == (c,d,e) so == (0 + c + d + e) - a - b
f(a,b)             # x is () so == 0 - a - b


#  Calling a function with named arguments:
# Functions with keyword arguments are defined using a semicolon in the function signature,
#  as in
#             function plot(x, y; style="solid", width=1, color="black")
#
# When the function is called, the semicolon is optional, so plot here can be
# either called with plot(x, y, width=2) or less commonly as plot(x, y; width=2).


#  Using a function in statement context:
#  Any function can be used as a variable by its name.

circlearea(x) = x^2 * pi
map(circlearea, [r1, r2, r3, r4])


#  Using a function in first-class context within an expression:
cylindervolume = circlearea(r) * h


#  Obtaining the return value of a function:
radius = 2.5
area = circlearea(2.5)


#  Distinguishing built-in functions and user-defined functions:
#  Julia does not attempt to distinguish these in any special way,
#  but at the REPL command line there is ? help available for builtin
#  functions that would not generally be available for the user-defined ones.


#  Distinguishing subroutines and functions:
#  All subroutines are called functions in Julia, regardless of whether they return values.


#  Stating whether arguments are passed by value or by reference:
#  As in Python, all arguments are passed by pointer reference, but assignment to a passed argument
#  only changes the variable within the function. Assignment to the values referenced by the argument
## DOES however change those values. For instance:

a = 3
b = [3]
c = [3]

function f(x, y)
    a = 0
    b[1] = 0
    c = [0]
end # a and c are now unchanged but b = [0]


#  Is partial application possible and how:
#  In Julia, there are many different ways to compose functions. In particular,
#  Julia has an "arrow" operator -> that may be used to curry other functions.

f(a, b) = a^2 + a + b
v = [4, 6, 8]
map(x -> f(x, 10), v)  # v = [30, 52, 82]
