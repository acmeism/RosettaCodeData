def preorder;
preorder = { Node node ->
    ([node] + node.children().collect { preorder(it) }).flatten()
}

def postorder;
postorder = { Node node ->
    (node.children().collect { postorder(it) } + [node]).flatten()
}

def inorder;
inorder = { Node node ->
    def kids = node.children()
    if (kids.empty) [node]
    else if (kids.size() == 1 &&  kids[0].'@right') [node] + inorder(kids[0])
    else inorder(kids[0]) + [node] + (kids.size()>1 ? inorder(kids[1]) : [])
}

def levelorder = { Node node ->
    def nodeList = []
    def level = [node]
    while (!level.empty) {
        nodeList += level
        def nextLevel = level.collect { it.children() }.flatten()
        level = nextLevel
    }
    nodeList
}

class BinaryNodeBuilder extends NodeBuilder {
    protected Object postNodeCompletion(Object parent, Object node) {
        assert node.children().size() < 3
        node
    }
}
