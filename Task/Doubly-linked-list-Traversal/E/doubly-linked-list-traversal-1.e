def traverse(list) {
    var node := list.atFirst()
    while (true) {
        println(node[])
        if (node.hasNext()) {
            node := node.next()
        } else {
            break
        }
    }
    while (true) {
        println(node[])
        if (node.hasPrev()) {
            node := node.prev()
        } else {
            break
        }
    }
}
