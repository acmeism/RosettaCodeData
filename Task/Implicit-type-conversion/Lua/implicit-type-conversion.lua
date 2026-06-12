-- During concatenation, numbers are always converted to strings. arithmetic operations will attempt to coerce strings to numbers, or throw an error if they can't
type(123 .. "123") --> string
type(123 + "123") --> number
type(123 + "foo") --> error thrown

-- Because Lua supports multiple returns, there is a concept of "no" value when a function does not return anything, or does not return enough. If Lua is expecting a value, it will coerce these "nothing" values into nil. The same applies for lists of values in general.
function noop () end
local a = noop()
print(a) --> nil
local x, y, z = noop()
print(x, y, z) --> nil nil nil

-- As in many languages, all types can be automatically coerced into their boolean value if required. Only nil and false will coerce to false
print(not not nil, not not false, not not 1, not not "foo", not not { }) --> false false true true true
