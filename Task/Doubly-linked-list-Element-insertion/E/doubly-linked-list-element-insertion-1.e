def insert(after, value) {
    def newNode := makeElement(value, after, after.getNext())
    after.getNext().setPrev(newNode)
    after.setNext(newNode)
}
