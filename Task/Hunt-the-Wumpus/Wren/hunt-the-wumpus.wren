import "random" for Random
import "/fmt" for Fmt
import "/ioutil" for Input
import "/str" for Str

var cave = {
     1: [ 2,  3,  4],  2: [ 1,  5,  6],  3: [ 1,  7,  8],  4: [ 1,  9, 10],
     5: [ 2,  9, 11],  6: [ 2,  7, 12],  7: [ 3,  6, 13],  8: [ 3, 10, 14],
     9: [ 4,  5, 15], 10: [ 4,  8, 16], 11: [ 5, 12, 17], 12: [ 6, 11, 18],
    13: [ 7, 14, 18], 14: [ 8, 13, 19], 15: [ 9, 16, 17], 16: [10, 15, 19],
    17: [11, 20, 15], 18: [12, 13, 20], 19: [14, 16, 20], 20: [17, 18, 19]
}

var player
var wumpus
var batt1
var bat2
var pit1
var pit2
var arrows = 5

var isEmpty = Fn.new { |r|
    if (r != player && r != wumpus && r != bat1 && r != bat2 && r != pit1 && r != pit2) {
        return true
    }
    return false
}

var sense = Fn.new { |adj|
    var bat = false
    var pit = false
    for (ar in adj) {
        if (ar == wumpus) System.print("You smell something terrible nearby.")
        if (ar == bat1 || ar == bat2) {
            if (!bat) {
                System.print("You hear a rustling.")
                bat = true
            }
        } else if (ar == pit1 || ar == pit2) {
            if (!pit) {
                System.print("You feel a cold wind blowing from a nearby cavern.")
                pit = true
            }
        }
    }
    System.print()
}

var plural = Fn.new { |n| (n != 1) ? "s" : "" }

var rand = Random.new()
player = 1
wumpus = rand.int(2, 21)
bat1   = rand.int(2, 21)
while (true) {
    bat2 = rand.int(2, 21)
    if (bat2 != bat1) break
}
while (true) {
    pit1 = rand.int(2, 21)
    if (pit1 != bat1 && pit1 != bat2) break
}
while (true) {
    pit2 = rand.int(2, 21)
    if (pit2 != bat1 && pit2 != bat2 && pit2 != pit1) break
}
while (true) {
    Fmt.print("\nYou are in room $d with $d arrow$s left", player, arrows, plural.call(arrows))
    var adj = cave[player]
    System.print("The adjacent rooms are %(adj)")
    sense.call(adj)
    var room = Input.intOpt("Choose an adjacent room : ", adj)
    var action = Str.lower(Input.option("Walk or shoot w/s : ", "wsWS"))
    if (action == "w") {
        player = room
        if (player == wumpus) {
            System.print("You have been eaten by the Wumpus and lost the game!")
            return
        } else if (player == pit1 || player == pit2) {
            System.print("You have fallen down a bottomless pit and lost the game!")
            return
        } else if (player == bat1 || player == bat2) {
            while (true) {
                room = rand.int(2, 20)
                if (isEmpty.call(room)) {
                    System.print("A bat has transported you to a random empty room")
                    player = room
                    break
                }
            }
        }
    } else {
        if (room == wumpus) {
            System.print("You have killed the Wumpus and won the game!!")
            return
        } else {
            var chance = rand.int(4) // 0 to 3
            if (chance > 0) {        // 75% probability
                wumpus = cave[wumpus][rand.int(3)]
                if (player == wumpus) {
                    System.print("You have been eaten by the Wumpus and lost the game!")
                    return
                }
            }
        }
        arrows = arrows - 1
        if (arrows == 0) {
            System.print("You have run out of arrows and lost the game!")
            return
        }
    }
}
