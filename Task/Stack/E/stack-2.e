def makeStack() {
    var store := null
    def stack {
        to push(x) { store := [x, store] }
        to pop() { def [x, next] := store; store := next; return x }
        to last() { return store[0] }
        to empty() { return (store == null) }
    }
    return stack
}

? def s := makeStack()
# value: <stack>

? s.push(1)
? s.push(2)
? s.last()
# value: 2

? s.pop()
# value: 2

? s.empty()
# value: false

? s.pop()
# value: 1

? s.empty()
# value: true
