def a(x): "  a(\(x))" | stderr | x;

def b(y): "  b(\(y))" | stderr | y;

"and:", (a(true) and b(true)),
"or:",  (a(true) or b(true)),
"and:", (a(false) and b(true)),
"or:",  (a(false) or b(true))
