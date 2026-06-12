// version 1.1.4-3

fun main(args: Array<String>) {
    print("Enter the number of resources: ")
    val r = readLine()!!.toInt()

    print("\nEnter the number of processes: ")
    val p = readLine()!!.toInt()

    print("\nEnter Claim Vector: ")
    val maxRes = readLine()!!.split(' ').map { it.toInt() } .toIntArray()

    println("\nEnter Allocated Resource Table:")
    val curr = Array(p) { IntArray(r) }
    for (i in 0 until p) {
        print("Row ${i + 1}:  ")
        curr[i] = readLine()!!.split(' ').map { it.toInt() }.toIntArray()
    }

    println("\nEnter Maximum Claim Table: ")
    val maxClaim = Array(p) { IntArray(r) }
    for (i in 0 until p) {
        print("Row ${i + 1}:  ")
        maxClaim[i] = readLine()!!.split(' ').map { it.toInt() }.toIntArray()
    }

    val alloc = IntArray(r)
    for (i in 0 until p) {
        for (j in 0 until r) alloc[j] += curr[i][j]
    }
    println("\nAllocated Resources: ${alloc.joinToString(" ")}")

    val avl = IntArray(r) { maxRes[it] - alloc[it] }
    println("\nAvailable Resources: ${avl.joinToString(" ")}")

    val running = BooleanArray(p) { true }
    var count = p
    while (count != 0) {
        var safe = false
        for (i in 0 until p) {
            if (running[i]) {
                var exec = true
                for (j in 0 until r) {
                    if (maxClaim[i][j] - curr[i][j] > avl[j]) {
                        exec = false
                        break
                    }
                }

                if (exec) {
                    print("\nProcess ${i + 1} is executing.\n")
                    running[i] = false
                    count--
                    safe = true
                    for (j in 0 until r) avl[j] += curr[i][j]
                    break
                }
            }
        }

        if (!safe) {
            print("The processes are in an unsafe state.")
            break
        }

        print("\nThe process is in a safe state.")
        println("\nAvailable Vector: ${avl.joinToString(" ")}")
    }
}
