MODE F = PROC(REAL)REAL; # ALGOL 68 is strong typed #

# As a procedure for real to real functions #
PROC compose = (F f, g)F: (REAL x)REAL: f(g(x));

OP (F,F)F O = compose; # or an OPerator that can be overloaded #

# Example use: #
F sin arc sin = compose(sin, arc sin);
print((sin arc sin(0.5), (sin O arc sin)(0.5), new line))
