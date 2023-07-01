class TreeNode<T> {
    let value: T
    let left: TreeNode?
    let right: TreeNode?

    init(value: T, left: TreeNode? = nil, right: TreeNode? = nil) {
        self.value = value
        self.left = left
        self.right = right
    }

    func preOrder(function: (T) -> Void) {
        function(value)
        if left != nil {
            left!.preOrder(function: function)
        }
        if right != nil {
            right!.preOrder(function: function)
        }
    }

    func inOrder(function: (T) -> Void) {
        if left != nil {
            left!.inOrder(function: function)
        }
        function(value)
        if right != nil {
            right!.inOrder(function: function)
        }
    }

    func postOrder(function: (T) -> Void) {
        if left != nil {
            left!.postOrder(function: function)
        }
        if right != nil {
            right!.postOrder(function: function)
        }
        function(value)
    }

    func levelOrder(function: (T) -> Void) {
        var queue: [TreeNode] = []
        queue.append(self)
        while queue.count > 0 {
            let node = queue.removeFirst()
            function(node.value)
            if node.left != nil {
                queue.append(node.left!)
            }
            if node.right != nil {
                queue.append(node.right!)
            }
        }
    }
}

typealias Node = TreeNode<Int>

let n = Node(value: 1,
             left: Node(value: 2,
                        left: Node(value: 4,
                                   left: Node(value: 7)),
                        right: Node(value: 5)),
             right: Node(value: 3,
                         left: Node(value: 6,
                                    left: Node(value: 8),
                                    right: Node(value: 9))))

let fn = { print($0, terminator: " ") }

print("pre-order:   ", terminator: "")
n.preOrder(function: fn)
print()

print("in-order:    ", terminator: "")
n.inOrder(function: fn)
print()

print("post-order:  ", terminator: "")
n.postOrder(function: fn)
print()

print("level-order: ", terminator: "")
n.levelOrder(function: fn)
print()
