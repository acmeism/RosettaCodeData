def p = new Point(x: 3, y: 4)
def c = new Circle(x: 4, y: 3, r: 5)

[(p): new Point(p), (c): new Circle(c)].each { v1, v2 ->
    print "Verifying $v1 == "
    v2.print()
    assert v1 == v2
}
