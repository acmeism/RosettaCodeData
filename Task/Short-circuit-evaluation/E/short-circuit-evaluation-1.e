def a(v) { println("a"); return v }
def b(v) { println("b"); return v }

def x := a(i) && b(j)
def y := b(i) || b(j)
