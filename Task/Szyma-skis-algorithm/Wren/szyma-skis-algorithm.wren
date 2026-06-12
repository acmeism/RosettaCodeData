import "random" for Random

var rand = Random.new()

var flag = {}

var allszy = (1..6).toList

var criticalValue = 1

var runSzymanski = Fn.new { |id|
    var others = allszy.where { |t| t != id }.toList
    flag[id] = 1                                   // Standing outside waiting room
    while (!others.all { |t| flag[t] < 3}) {       // Wait for open door
        Fiber.yield()
    }
    flag[id] = 3                                   // Standing in doorway
    if (others.any { |t| flag[t] == 1 }) {         // Another fiber is waiting to enter
        flag[id] = 2                               // Waiting for other fibers to enter
        while (!others.any { |t| flag[t] == 4 }) { // Wait for a fiber to enter & close door
            Fiber.yield()
        }
    }
    flag[id] = 4                                   // The door is closed
    for (t in others) {                            // Wait for everyone of lower id to exit
        if (t >= id) continue
        while (flag[t] > 1) Fiber.yield()
    }

    // critical section
    criticalValue = criticalValue + id * 3
    criticalValue = (criticalValue/2).floor
    System.print("Fiber %(id) changed the critical value to %(criticalValue).")
    // end critical section

    // exit protocol
    for (t in others) {                            // Ensure everyone in the waiting room has
        if (t <= id) continue                      // realized door is supposed to be closed
        while (![0, 1, 4].contains(flag[t])) {
            Fiber.yield()
        }
    }
    flag[id] = 0                                   // Leave. Reopen door if nobody is still
                                                   // in the waiting room
}

var testSzymanski = Fn.new {
    var fibers = List.filled(6, 0)
    for (id in 1..6) {
        fibers[id-1] = Fiber.new(runSzymanski)
        flag[id] = 0
    }
    rand.shuffle(allszy)
    for (id in allszy) {
        fibers[id-1].call(id)
    }
}

testSzymanski.call()
