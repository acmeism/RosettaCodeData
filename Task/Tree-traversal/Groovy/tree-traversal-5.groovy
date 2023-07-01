def test = { tree ->
    println "preorder:    ${preorder(tree).collect{it.name()}}"
    println "preorder:    ${tree.depthFirst().collect{it.name()}}"

    println "postorder:   ${postorder(tree).collect{it.name()}}"

    println "inorder:     ${inorder(tree).collect{it.name()}}"

    println "level-order: ${levelorder(tree).collect{it.name()}}"
    println "level-order: ${tree.breadthFirst().collect{it.name()}}"

    println()
}
test(tree1)
test(tree2)
