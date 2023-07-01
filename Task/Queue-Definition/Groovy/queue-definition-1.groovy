class Queue {
    private List buffer

    public Queue(List buffer =  new LinkedList()) {
        assert buffer != null
        assert buffer.empty
        this.buffer = buffer
    }

    def push (def item) { buffer << item }
    final enqueue = this.&push

    def pop() {
        if (this.empty) throw new NoSuchElementException('Empty Queue')
        buffer.remove(0)
    }
    final dequeue = this.&pop

    def getEmpty() { buffer.empty }

    String toString() { "Queue:${buffer}" }
}
