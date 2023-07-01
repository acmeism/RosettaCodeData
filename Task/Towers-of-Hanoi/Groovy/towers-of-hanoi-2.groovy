enum Ring {
    S('°'), M('o'), L('O'), XL('( )');
    private sym
    private Ring(sym) { this.sym=sym }
    String toString() { sym }
}

report = { STACK.each { k, v ->  println "${k}: ${v}" }; println() }
check = { to -> assert to == ([] + to).sort().reverse() }

Ring.values().reverseEach { STACK.A << it }
report()
check(STACK.A)
moveStack(STACK.A, STACK.C)
