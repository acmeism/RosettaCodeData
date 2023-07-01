#!/usr/bin/awk -f

BEGIN {
    delete q
    print "empty? " emptyP()
    print "push " push("a")
    print "push " push("b")
    print "empty? " emptyP()
    print "pop " pop()
    print "pop " pop()
    print "empty? " emptyP()
    print "pop " pop()
}

function push(n) {
    q[length(q)+1] = n
    return n
}

function pop() {
    if (emptyP()) {
        print "Popping from empty queue."
        exit
    }
    r = q[length(q)]
    delete q[length(q)]
    return r
}

function emptyP() {
    return length(q) == 0
}
