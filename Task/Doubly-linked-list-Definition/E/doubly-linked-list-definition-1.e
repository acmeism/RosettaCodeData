def makeDLList() {
    def firstINode
    def lastINode

    def makeNode(var value, var prevI, var nextI) {
        # To meet the requirement that the client cannot create a loop, the
        # inter-node refs are protected: clients only get the external facet
        # with invariant-preserving operations.
        def iNode

        def node { # external facet

            to get() { return value }
            to put(new) { value := new }

            /** Return the value of the element of the list at the specified offset
                from this element. */
            to get(index :int) {
                if (index > 0 && node.hasNext()) {
                    return nextI.node().get(index - 1)
                } else if (index < 0 && node.hasPrev()) {
                    return prevI.node().get(index + 1)
                } else if (index <=> 0) {
                    return value
                } else {
                    throw("index out of range in dlList")
                }
            }
            to hasPrev() {
                return prevI != firstINode && prevI != null
            }
            to prev() {
                if (!node.hasPrev()) {
                    throw("there is no previous node")
                }
                return prevI.node()
            }
            to hasNext() {
                return nextI != lastINode && nextI != null
            }
            to next() {
                if (!node.hasNext()) {
                    throw("there is no next node")
                }
                return nextI.node()
            }
            to remove() {
                if (prevI == null || nextI == null) { return }
                prevI.setNextI(nextI)
                nextI.setPrevI(prevI)
                prevI := null
                nextI := null
            }
            to insertAfter(newValue) {
                def newI := makeNode(newValue, iNode, nextI)
                nextI.setPrevI(newI)
                nextI := newI
            }
            to insertBefore(newValue) {
                prevI.node().insertAfter(newValue)
            }
        }

        bind iNode { # internal facet
            to node() { return node }
            to nextI() { return nextI }
            to prevI() { return prevI }
            to setNextI(new) { nextI := new }
            to setPrevI(new) { prevI := new }
        }

        return iNode
    } # end makeNode

    bind firstINode := makeNode(null, Ref.broken("no first prev"), lastINode)
    bind lastINode := makeNode(null, firstINode, Ref.broken("no last next"))

    def dlList {
        to __printOn(out) {
            out.print("<")
            var sep := ""
            for x in dlList {
                out.print(sep)
                out.quote(x)
                sep := ", "
            }
            out.print(">")
        }
        to iterate(f) {
            var n := firstINode
            while (n.node().hasNext()) {
                n := n.nextI()
                f(n.node(), n.node()[])
            }
        }
        to atFirst() { return firstINode.nextI().node() }
        to atLast() { return lastINode.prevI().node() }
        to insertFirst(new) { return firstINode.node().insertAfter(new) }
        to push(new) { return lastINode.node().insertBefore(new) }

        /** Return the node which has the specified value */
        to nodeOf(value) {
            for node => v ? (v == value) in dlList { return node }
        }
    }
    return dlList
}
