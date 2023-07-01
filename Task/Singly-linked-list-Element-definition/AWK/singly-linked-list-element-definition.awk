BEGIN {
    NIL = 0
    HEAD = 1
    LINK = 1
    VALUE = 2

    delete list
    initList()
}

function initList() {
    delete list
    list[HEAD] = makeNode(NIL, NIL)
}

function makeNode(link, value) {
    return link SUBSEP value
}

function getNode(part, nodePtr,    linkAndValue) {
    split(list[nodePtr], linkAndValue, SUBSEP)
    return linkAndValue[part]
}
