{.checks: off, optimization: speed.}    # Checks are deactivated and code is generated for speed.

# Define a type Color as pure which implies that value names are declared in their own scope
# and may/should be accessed with their type qualifier (as Color.Red).
type Color {.pure.} = enum Red, Green, Blue

# Declare a procedure to inline if possible.
proc odd(x: int): bool {.inline.} = (x and 1) != 0

# Declaration of a C external procedure.
proc printf(formatstr: cstring) {.header: "<stdio.h>", importc: "printf", varargs.}

# Declaration of a deprecated procedure. If not used, no warning will be emitted.
proc notUsed(x: int) {.used, deprecated.} = echo x

# Declaration of a type with an alignment constraint.
type SseType = object
  sseData {.align(16).}: array[4, float32]

# Declaration of a procedure containing a variable to store in register, if possible, and a variable to store as global.
proc p() =
  var x {.register.}: int
  var y {.global.} = "abcdef"

{.push checks: on.}
# From here, checks are activated.
...
{.pop.}
# From here, checks are deactivated again.
