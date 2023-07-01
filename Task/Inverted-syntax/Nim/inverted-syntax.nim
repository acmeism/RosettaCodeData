#--
# if statements
#--

template `?`(expression, condition) =
  if condition:
    expression

let raining = true
var needUmbrella: bool

# Normal syntax
if raining: needUmbrella = true

# Inverted syntax
(needUmbrella = true) ? (raining == true)

#--
# Assignments
#--

template `~=`(right, left) =
  left = right

var a = 3

# Normal syntax
a = 6

# Inverted syntax
6 ~= a
