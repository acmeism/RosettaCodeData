var linkedList := makeLink(1, makeLink(2, makeLink(3, empty)))

while (!(linkedList.null())) {
    println(linkedList.value())
    linkedList := linkedList.next()
}
