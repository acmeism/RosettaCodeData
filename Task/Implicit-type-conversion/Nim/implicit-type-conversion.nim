const A = 1           # "1" is considered as as int, so this is the type of "x".
const B: float = 1    # Implicit conversion from int to float done by the compiler.

var x: uint = 1       # Implicit conversion from int to uint done by the compiler.
var y = 1f32          # "y" is a float32.
var z: float64 = y    # The compiler generates code to convert from float32 to float64.

# Tuple conversions.
# Note that these conversions doesn’t change the memory representation of the data.

var t1: tuple[a, b: int]    # Named tuple.
var t2: tuple[c, d: int]    # Named tuple, incompatible with the previous one.
var t3: (int, int)          # Unnamed tuple.

t3 = (1, 2)           # No conversion here.
t1 = t3               # Implicit conversion from unnamed to named.
t2 = (int, int)(t1)   # Explicit conversion followed by an implicit conversion.
t3 = t2               # Implicit conversion from named to unnamed.

# Simplifying operations with "lenientops".
var f1, f2, f3: float
var i1, i2, i3: int

f1 = f2 + i1.toFloat * (f3 * i2.toFloat) + i3.toFloat

import lenientops

f1 = f2 + i1 * (f3 * i2) + i3   # Looks like implicit conversions for the user.

# Another example: / operator.
# This operator is defined for float32 and float64 operands. But is also defined
# for integer operands in "system" module. Actually, it simply converts the operands
# to float and apply the float division. This is another example of overloading
# hiding the conversions.
echo 1 / 2  # Displays 0.5.

# Converter examples.
# The following ones are absolutely not recommended as Nim is not C or Python.
converter toInt(b: bool): int = ord(b)
converter toBool(i: int): bool = i != 0

echo 1 + true       # Displays 2.
if 2: echo "ok"     # Displays "ok".
