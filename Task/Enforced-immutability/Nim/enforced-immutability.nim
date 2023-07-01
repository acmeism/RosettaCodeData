var x = "mutablefoo" # Mutable variable
let y = "immutablefoo" # Immutable variable, at runtime
const z = "constantfoo" # Immutable constant, at compile time

x[0] = 'M'
y[0] = 'I' # Compile error: 'y[0]' cannot be assigned to
z[0] = 'C' # Compile error: 'z[0]' cannot be assigned to
