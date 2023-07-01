when NimVersion < "1.2":
  error "This compiler is too old"                       # Error at compile time.

assert NimVersion >= "1.4", "This compiler is too old."  # Assertion defect at runtime.

var bloop = -12

when compiles abs(bloop):
  echo abs(bloop)
