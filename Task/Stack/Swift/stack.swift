struct Stack<T> {
    var items = [T]()
    var empty:Bool {
        return items.count == 0
    }

    func peek() -> T {
        return items[items.count - 1]
    }

    mutating func pop() -> T {
        return items.removeLast()
    }

    mutating func push(obj:T) {
        items.append(obj)
    }
}

var stack = Stack<Int>()
stack.push(1)
stack.push(2)
println(stack.pop())
println(stack.peek())
stack.pop()
println(stack.empty)
