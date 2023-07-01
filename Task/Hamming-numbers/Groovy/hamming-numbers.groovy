class Hamming {

    static final ONE = BigInteger.ONE
    static final THREE = BigInteger.valueOf(3)
    static final FIVE = BigInteger.valueOf(5)

    static void main(args) {
        print 'Hamming(1 .. 20) ='
        (1..20).each {
            print " ${hamming it}"
        }
        println "\nHamming(1691) = ${hamming 1691}"
        println "Hamming(1000000) = ${hamming 1000000}"
    }

    static hamming(n) {
        def priorityQueue = new PriorityQueue<BigInteger>()
        priorityQueue.add ONE

        def lowest

        n.times {
            lowest = priorityQueue.poll()
            while (priorityQueue.peek() == lowest) {
                priorityQueue.poll()
            }
            updateQueue(priorityQueue, lowest)
        }

        lowest
    }

    static updateQueue(priorityQueue, lowest) {
        priorityQueue.add(lowest.shiftLeft 1)
        priorityQueue.add(lowest.multiply THREE)
        priorityQueue.add(lowest.multiply FIVE)
    }
}
