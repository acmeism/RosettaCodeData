import "/queue" for PriorityQueue

var tasks = PriorityQueue.new()
tasks.push("Clear drains", 3)
tasks.push("Feed cat", 4)
tasks.push("Make tea", 5)
tasks.push("Solve RC tasks", 1)
tasks.push("Tax return", 2)
while (!tasks.isEmpty) {
    var t = tasks.pop()
    System.print(t)
}
