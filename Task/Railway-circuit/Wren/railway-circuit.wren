import "./seq" for Lst
import "./math" for Int, Nums

// Returns whether 'a' and 'b' are approximately equal within a tolerance of 'tol'.
var IsApprox = Fn.new { |a, b, tol| (a - b).abs <= tol }

// Returns whether a1 < a2 where 'a1' and 'a2' are lists of numbers.
var isLess = Fn.new { |a1, a2|
    for (pair in Lst.zip(a1, a2)) {
        if (pair[0] > pair[1]) return false
        if (pair[0] < pair[1]) return true
    }
    return a1.count < a2.count
}

// Represents a 2D point.
class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    +(other) { Point.new(this.x + other.x, this.y + other.y) }

    ==(other) { IsApprox.call(this.x, other.x, 0.01) && IsApprox.call(this.y, other.y, 0.01) }

    toString { "(%(_x), %(_y))" }
}

// A curve section 30 degrees is 1/12 of a circle angle or π/6 radians.
var twelveSteps = List.filled(12, null)
for (a in 0..11) twelveSteps[a] = Point.new((Num.pi * (a+1)/6).sin, (Num.pi * (a+1)/6).cos)

// A straight section 90 degree angle is 1/4 of a circle angle or π/2 radians.
var fourSteps = List.filled(4, null)
for (a in 0..3) fourSteps[a] = Point.new((Num.pi * (a+1)/2).sin, (Num.pi * (a+1)/2).cos)

// Returns whether 'turns' and 'groupMember' are in an equivalence group.
var isInEquivalenceGroup = Fn.new { |turns, groupMember, reversals|
    if (Lst.areEqual(groupMember, turns)) return true
    var turns2 = turns.toList
    for (i in 1...turns.count) {
        if (Lst.areEqual(groupMember, Lst.rshift(turns2, 1))) return true
    }
    var invTurns = turns.map { |e| (e == 0) ? 0 : -e }.toList
    if (Lst.areEqual(groupMember, invTurns)) return true
    for (i in 1...invTurns.count) {
        if (Lst.areEqual(groupMember, Lst.rshift(invTurns, 1))) return true
    }
    if (reversals) {
        var revTurns = turns[-1..0]
        if (Lst.areEqual(groupMember, revTurns)) return true
        var revTurns2 = revTurns.toList
        for (i in 1...revTurns.count) {
            if (Lst.areEqual(groupMember, Lst.rshift(revTurns2, 1))) return true
        }
        invTurns = revTurns.map { |e| (e == 0) ? 0 : -e }.toList
        if (Lst.areEqual(groupMember, invTurns)) return true
        for (i in 1...invTurns.count) {
            if (Lst.areEqual(groupMember, Lst.rshift(invTurns, 1))) return true
        }
    }
    return false
}

// Returns the maximum member of the equivalence group containing 'turns'.
var maximumOfSymmetries = Fn.new { |turns, groupsFound, reversals|
    var maxOfGroup = turns.toList
    for (i in 0...turns.count) {
        var t = Lst.rshift(turns.toList, i)
        groupsFound[t.toString] = true
        if (isLess.call(maxOfGroup, t)) maxOfGroup = t
    }
    var invTurns = turns.map { |e| (e == 0) ? 0 : -e }
    for (i in 0...invTurns.count) {
        var t = Lst.rshift(invTurns.toList, i)
        groupsFound[t.toString] = true
        if (isLess.call(maxOfGroup, t)) maxOfGroup = t
    }
    if (reversals) {
        var revTurns = turns[-1..0]
        for (i in 0...revTurns.count) {
            var t = Lst.rshift(revTurns.toList, i)
            groupsFound[t.toString] = true
            if (isLess.call(maxOfGroup, t)) maxOfGroup = t
        }
        var revInvTurns = revTurns.map { |e| (e == 0) ? 0 : -e }
        for (i in 0...revInvTurns.count) {
            var t = Lst.rshift(revInvTurns.toList, i)
            groupsFound[t.toString] = true
            if (isLess.call(maxOfGroup, t)) maxOfGroup = t
        }
    }
    return maxOfGroup
}

// Returns true if the path of 'turns' returns to starting point, and on that return is
// moving in a direction opposite to the starting direction.
var isClosedPath = Fn.new { |turns, straight, start|
    if ((Nums.sum(turns) % (straight ? 4 : 12)) != 0) return false
    var angle = 0
    var point = Point.new(start.x, start.y)
    if (straight) {
        for (turn in turns) {
            angle = angle + turn
            point = point + fourSteps[angle % 4]
        }
    } else {
        for (turn in turns) {
            angle = angle + turn
            point = point + twelveSteps[angle % 12]
        }
    }
    return point == start
}

// Finds and returns all valid circuits on the following basis.
//
// Count the complete circuits by their equivalence groups. Show the unique
// highest sorting lists from each equivalence group if verbose.
//
// Use 30 degree curved track if straight is false, otherwise straight track.
//
// Allow reversed circuits if otherwise in another grouup if reversals is false,
// otherwise do not consider reversed order lists unique.
var allValidCircuits = Fn.new { |n, verbose, straight, reversals|
    var found = []
    var groupMembersFound = {}
    var t1 = straight ? "straight" : "curved"
    var t2 = (reversals ? "excl" : "incl") + "uding reversed curves: "
    System.print("\nFor N of %(n) and %(t1) track, %(t2)")
    for (i in 0..(straight ? 3.pow(n)-1 : 2.pow(n)-1)) {
        var turns
        if (straight) {
            var digs = Int.digits(i, 3)[-1..0]
            if (digs.count < n) digs = digs + ([0] * (n - digs.count))
            turns = digs.map { |d| (d == 0) ? 0 : ((d == 1) ? 1 : -1) }.toList
        } else {
            var digs = Int.digits(i, 2)[-1..0]
            if (digs.count < n ) digs = digs + ([0] * (n - digs.count))
            turns = digs.map { |d| (d == 0) ? 1 : -1 }.toList
        }
        if (isClosedPath.call(turns, straight, Point.new(0, 0)) &&
            !groupMembersFound.containsKey(turns.toString)) {
            if (found.isEmpty || found.all { |t| !isInEquivalenceGroup.call(turns, t, false) }) {
                var canon = maximumOfSymmetries.call(turns, groupMembersFound, reversals)
                if (verbose) System.print(canon)
                found.add(canon)
            }
        }
    }
    System.print("Found %(found.count) unique valid circuit(s).")
    return found
}

var n = 4
while (n <= 24) {
    for (rev in [false, true]) {
        for (str in [false, true]) {
            if (str && n > 14) continue
            allValidCircuits.call(n, !str, str, rev)
        }
    }
    n = n + 2
}
