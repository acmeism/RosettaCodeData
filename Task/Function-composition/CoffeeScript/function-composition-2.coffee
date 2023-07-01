Function::of = (f) -> (args...) => @ f args...

# Example
add2 = (x) -> x + 2
mul2 = (x) -> x * 2

mulFirst = add2.of mul2
addFirst = mul2.of add2
multiple = mul2.of add2.of mul2

console.log "add2 2 #=> #{ add2 2 }"
console.log "mul2 2 #=> #{ mul2 2 }"
console.log "mulFirst 2 #=> #{ mulFirst 2 }"
console.log "addFirst 2 #=> #{ addFirst 2 }"
console.log "multiple 2 #=> #{ multiple 2 }"
