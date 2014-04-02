def fs = { fn, values -> values.collect { fn(it) } }
def f1 = { v -> v * 2 }
def f2 = { v -> v ** 2 }
def fsf1 = fs.curry(f1)
def fsf2 = fs.curry(f2)
