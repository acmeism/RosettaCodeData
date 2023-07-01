def oldFunc = { arg1, arg2 -> arg1 + arg2 }
def newFunc = oldFunc.curry(30)
assert newFunc(12) == 42
