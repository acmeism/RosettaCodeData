# arity-0:
def f: "I have no arguments";

# arity-1:
def f(a1): a1;

# arity-1:
def f(a1;a2): a1,a2;

def f(a1;a2;a3): a1,a2,a3;

# Example:
f, f(1), f(2;3), f(4;5;6)
