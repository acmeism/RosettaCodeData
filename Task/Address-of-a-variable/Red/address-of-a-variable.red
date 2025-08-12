Red/System []

print ["pointer test:" newline]

a: 100
print ["a is an integer variable, value: " a newline]

p: declare pointer! [integer!]
p: :a
print ["p is the address of a: " p newline]
print ["p/value refer to the value pointed to by p: " p/value newline]

q: declare pointer! [integer!]
q: p + 1
print ["q is p + 1: " q " q/value is (uninitialized): " q/value newline]

print ["q - p: " (q - p) newline]
