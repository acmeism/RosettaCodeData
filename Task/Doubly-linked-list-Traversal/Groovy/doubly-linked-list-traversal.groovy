class DoubleLinkedListTraversing {
    static void main(args) {
        def linkedList = (1..9).collect() as LinkedList

        linkedList.each {
            print it
        }

        println()

        linkedList.reverseEach {
            print it
        }
    }
}
