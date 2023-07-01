var x: int = 3                  # Declaration with type specification and initialization.

var y = 3                       # Declaration with type inferred to "int".

var z: int                      # Variable is initialized to 0.

let a = 13                      # Immutable variable.

# Using a var block to initialize.
var
  b, c: int = 10                # Two variables initialized to 10
  s* = "foobar"                 # This one is exported.

type Obj = ref object
  i: int
  s: string

var obj = Obj(i: 3, s: "abc")   # Initialization with an implicit allocation by "new".
echo obj.a, " ", obj.s          # Equivalent to obj[].a and obj[].s.

proc p =
  var xloc = 3
  echo x                        # Referencing a global variable.

  proc q =
    echo xloc                   # Referencing a variable in the enclosing scope.
