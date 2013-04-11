interface TreeAny guards TreeStamp {}
def Tree {
    to get(Value) {
        def Tree1 {
            to coerce(specimen, ejector) {
                def tree := TreeAny.coerce(specimen, ejector)
                if (tree.valueType() != Value) {
                    throw.eject(ejector, "Tree value type mismatch")
                }
                return tree
            }
        }
        return Tree1
    }
}

def makeTree(T, var value :T, left :nullOk[Tree[T]], right :nullOk[Tree[T]]) {
    def tree implements TreeStamp {
        to valueType() { return T }
        to map(f) {
            value := f(value)  # the declaration of value causes this to be checked
            if (left != null) {
                left.map(f)
            }
            if (right != null) {
                right.map(f)
            }
        }
    }
    return tree
}
