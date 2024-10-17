class Node(T)
  property left : Nil | Node(T)
  property right : Nil | Node(T)
  property data : T

  def initialize(@data, @left = nil, @right = nil)
  end

  def preorder_traverse
    print " #{data}"
    if left = @left
      left.preorder_traverse
    end
    if right = @right
      right.preorder_traverse
    end
  end

  def inorder_traverse
    if left = @left
      left.inorder_traverse
    end
    print " #{data}"
    if right = @right
      right.inorder_traverse
    end
  end

  def postorder_traverse
    if left = @left
      left.postorder_traverse
    end
    if right = @right
      right.postorder_traverse
    end
    print " #{data}"
  end

  def levelorder_traverse
    queue = Array(Node(T)).new
    queue << self

    until queue.size <= 0
      node = queue.shift

      unless node
        next
      end

      print " #{node.data}"

      if left = node.left
        queue << left
      end
      if right = node.right
        queue << right
      end
    end
  end
end

tree = Node(Int32).new(1,
  Node(Int32).new(2,
    Node(Int32).new(4,
      Node(Int32).new(7)),
    Node(Int32).new(5)),
  Node(Int32).new(3,
    Node(Int32).new(6,
      Node(Int32).new(8),
      Node(Int32).new(9))))

print "preorder:   "
tree.preorder_traverse
print "\ninorder:    "
tree.inorder_traverse
print "\npostorder:  "
tree.postorder_traverse
print "\nlevelorder: "
tree.levelorder_traverse
puts
