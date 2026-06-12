import "io" for Stdin, Stdout

System.write("Enter the number of resources: ")
Stdout.flush()
var r = Num.fromString(Stdin.readLine())

System.write("\nEnter the number of processes: ")
Stdout.flush()
var p = Num.fromString(Stdin.readLine())

System.write("\nEnter Claim Vector: ")
Stdout.flush()
var maxRes = Stdin.readLine().split(" ").map { |s| Num.fromString(s) }.toList

System.print("\nEnter Allocated Resource Table:")
var curr = List.filled(p, null)
for (i in 0...p) {
    System.write("Row %(i + 1):  ")
    Stdout.flush()
    curr[i] = Stdin.readLine().split(" ").map { |s| Num.fromString(s) }.toList
}

System.print("\nEnter Maximum Claim Table: ")
var maxClaim = List.filled(p, null)
for (i in 0...p) {
    System.write("Row %(i + 1):  ")
    Stdout.flush()
    maxClaim[i] = Stdin.readLine().split(" ").map { |s| Num.fromString(s) }.toList
}

var alloc = List.filled(r, 0)
for (i in 0...p) {
    for (j in 0...r) alloc[j] = alloc[j] + curr[i][j]
}
System.print("\nAllocated Resources: %(alloc.join(" "))")

var avl = List.filled(r, 0)
for (i in 0...r) avl[i] = maxRes[i] - alloc[i]
System.print("\nAvailable Resources: %(avl.join(" "))")

var running = List.filled(p, true)
var count = p
while (count != 0) {
    var safe = false
    for (i in 0...p) {
        if (running[i]) {
            var exec = true
            for (j in 0...r) {
                if (maxClaim[i][j] - curr[i][j] > avl[j]) {
                    exec = false
                    break
                }
            }

            if (exec) {
                System.print("\nProcess %(i + 1) is executing.")
                running[i] = false
                count = count - 1
                safe = true
                for (j in 0...r) avl[j] = avl[j] + curr[i][j]
                break
            }
        }
    }

    if (!safe) {
        System.print("\nThe processes are in an unsafe state.")
        break
    }

    System.write("\nThe process is in a safe state.")
    System.print("\nAvailable Vector: %(avl.join(" "))")
}
