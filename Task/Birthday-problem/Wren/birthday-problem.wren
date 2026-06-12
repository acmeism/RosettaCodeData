import "random" for Random
import "./fmt" for Fmt

var equalBirthdays = Fn.new { |nSharers, groupSize, nRepetitions|
    var rand = Random.new(12345)
    var eq = 0
    for (i in 0...nRepetitions) {
        var group = List.filled(365, 0)
        for (j in 0...groupSize) {
            var r = rand.int(group.count)
            group[r] = group[r] + 1
        }
        eq = eq + (group.any { |i| i >= nSharers } ? 1 : 0)
    }
    return eq * 100 / nRepetitions
}

var groupEst = 2
for (sharers in 2..5) {
    // Coarse
    var groupSize = groupEst + 1
    while (equalBirthdays.call(sharers, groupSize, 100) < 50) groupSize = groupSize + 1

    // Finer
    var inf = (groupSize - (groupSize - groupEst) / 4).floor
    for (gs in inf...groupSize + 999) {
        var eq = equalBirthdays.call(sharers, groupSize, 250)
        if (eq > 50) {
            groupSize = gs
            break
        }
    }

    // Finest
    for (gs in groupSize - 1...groupSize + 999) {
        var eq = equalBirthdays.call(sharers, gs, 50000)
        if (eq > 50) {
            groupEst = gs
            Fmt.write("$d independent people in a group of $3d ", sharers, gs)
            Fmt.print("share a common birthday $2.1f\%", eq)
            break
        }
    }
}
