class BinaryTree {
    construct new(T, value) {
        if (!(T is Class)) Fiber.abort ("T must be a class.")
        if (value.type != T) Fiber.abort("Value must be of type T.")
        _kind = T
        _value = value
        _left = null
        _right = null
    }

    // constructor overload to enable kind to be inferred from type of value
    static new (value) { new(value.type, value) }

    kind  { _kind }
    value { _value}
    value=(v) {
        if (v.type != _kind) Fiber.abort("Value must be of type %(_kind)")
        _value = v
    }

    left  { _left }
    right { _right }
    left=(b) {
        if (b.type != BinaryTree || b.kind != _kind) {
            Fiber.abort("Argument must be a BinaryTree of type %(_kind)")
        }
        _left = b
    }
    right=(b) {
        if (b.type != BinaryTree || b.kind != _kind) {
            Fiber.abort("Argument must be a BinaryTree of type %(_kind)")
        }
        _right = b
    }

    map(f) {
        var tree = BinaryTree.new(f.call(_value))
        if (_left) tree.left = left.map(f)
        if (_right) tree.right = right.map(f)
        return tree
    }

    showTopThree() { "(%(left.value), %(value), %(right.value))" }
}

var b    = BinaryTree.new(6)
b.left   = BinaryTree.new(5)
b.right  = BinaryTree.new(7)
System.print(b.showTopThree())

var b2   = b.map{ |i| i * 10 }
System.print(b2.showTopThree())
b2.value = "six" // generates an error because "six" is not a Num
