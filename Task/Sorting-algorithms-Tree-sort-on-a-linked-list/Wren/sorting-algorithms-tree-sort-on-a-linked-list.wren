import "./llist" for DLinkedList
import "./sort" for Cmp

class BinaryTree {
    construct new() {
        _node = null
        _leftSubTree  = null
        _rightSubTree = null
    }

    insert(item) {
        if (!_node) {
            _node = item
            _leftSubTree  = BinaryTree.new()
            _rightSubTree = BinaryTree.new()
        } else {
            var cmp = Cmp.default(item)
            if (cmp.call(item, _node) < 0) {
                _leftSubTree.insert(item)
            } else {
                _rightSubTree.insert(item)
            }
        }
    }

    inOrder() {
        if (!_node) return
        _leftSubTree.inOrder()
        System.write("%(_node) ")
        _rightSubTree.inOrder()
    }
}

var treeSort = Fn.new { |ll|
    var searchTree = BinaryTree.new()
    for (item in ll) searchTree.insert(item)
    System.write("%(ll.join(" ")) -> ")
    searchTree.inOrder()
    System.print()
}

var ll = DLinkedList.new([5, 3, 7, 9, 1])
treeSort.call(ll)
var ll2 = DLinkedList.new(["d", "c", "e", "b", "a"])
treeSort.call(ll2)
