proc no_args() =
  discard
# call
no_args()

proc fixed_args(x, y) =
  echo x
  echo y
# calls
fixed_args(1, 2)        # x=1, y=2
fixed_args 1, 2         # same call
1.fixed_args(2)         # same call


proc opt_args(x=1.0) =
  echo x
# calls
opt_args()              # 1
opt_args(3.141)         # 3.141

proc var_args(v: varargs[string, `$`]) =
  for x in v: echo x
# calls
var_args(1, 2, 3)       # (1, 2, 3)
var_args(1, (2,3))      # (1, (2, 3))
var_args()              # ()

## Named arguments
fixed_args(y=2, x=1)    # x=1, y=2

## As a statement
if true:
  no_args()

proc return_something(x): int =
  x + 1

var a = return_something(2)

## First-class within an expression
let x = return_something(19) + 10
let y = 19.return_something() + 10
let z = 19.return_something + 10
