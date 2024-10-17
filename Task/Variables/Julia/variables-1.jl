#declaration/assignment, declaration is optional
x::Int32 = 1
#datatypes are inferred dynamically, but can also be set thru convert functions and datatype literals
x = 1 #x is inferred as Int, which is Int32 for 32-bit machines, Int64 for 64-bit machines
#variable reference
julia>x
1

x = int8(1) #x is of type Int8
x = 1.0 #x is Float64
x = y = 1 #assign both x and y to 1
global x = 1 #assigns 1 to global variable x (used inside scope blocks)
local x = 1 #assigns 1 to local variable x (used inside scope blocks)
x = 'a' #x is a 'Char' type, designated by single quotes
x = "a" #x is a 1-element string, designated by double quotes
