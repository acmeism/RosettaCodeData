# Procedure declarations. All are named
proc noargs(): int
proc twoargs(a, b: int): int
proc anyargs(x: varargs[int]): int
proc optargs(a, b: int = 10): int

# Usage
discard noargs()
discard twoargs(1,2)
discard anyargs(1,2,3,4,5,6,7,8)
discard optargs(5)

# Procedure definitions
proc noargs(): int = echo "noargs"
proc twoargs(a, b: int): int = echo "twoargs"
proc anyargs(x: varargs[int]): int = echo "anyargs"
proc optargs(a: int, b = 10): int = echo "optargs"
