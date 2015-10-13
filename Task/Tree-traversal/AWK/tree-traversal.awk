function preorder(tree, node, res,  child) {
    if (node == "")
        return
    res[res["count"]++] = node
    split(tree[node], child, ",")
    preorder(tree,child[1],res)
    preorder(tree,child[2],res)
}

function inorder(tree, node, res,   child) {
    if (node == "")
        return
    split(tree[node], child, ",")
    inorder(tree,child[1],res)
    res[res["count"]++] = node
    inorder(tree,child[2],res)
}

function postorder(tree, node, res,     child) {
    if (node == "")
        return
    split(tree[node], child, ",")
    postorder(tree,child[1], res)
    postorder(tree,child[2], res)
    res[res["count"]++] = node
}

function levelorder(tree, node, res,    nextnode, queue, child) {
    if (node == "")
        return

    queue["tail"] = 0
    queue[queue["head"]++] = node

    while (queue["head"] - queue["tail"] >= 1) {

        nextnode = queue[queue["tail"]]
        delete queue[queue["tail"]++]

        res[res["count"]++] = nextnode

        split(tree[nextnode], child, ",")
        if (child[1] != "")
            queue[queue["head"]++] = child[1]
        if (child[2] != "")
            queue[queue["head"]++] = child[2]
    }
    delete queue
}

BEGIN {
    tree["1"] = "2,3"
    tree["2"] = "4,5"
    tree["3"] = "6,"
    tree["4"] = "7,"
    tree["5"] = ","
    tree["6"] = "8,9"
    tree["7"] = ","
    tree["8"] = ","
    tree["9"] = ","

    preorder(tree,"1",result)
    printf "preorder:\t"
    for (n = 0; n < result["count"]; n += 1)
        printf result[n]" "
    printf "\n"
    delete result

    inorder(tree,"1",result)
    printf "inorder:\t"
    for (n = 0; n < result["count"]; n += 1)
        printf result[n]" "
    printf "\n"
    delete result

    postorder(tree,"1",result)
    printf "postorder:\t"
    for (n = 0; n < result["count"]; n += 1)
        printf result[n]" "
    printf "\n"
    delete result

    levelorder(tree,"1",result)
    printf "level-order:\t"
    for (n = 0; n < result["count"]; n += 1)
        printf result[n]" "
    printf "\n"
    delete result
}
