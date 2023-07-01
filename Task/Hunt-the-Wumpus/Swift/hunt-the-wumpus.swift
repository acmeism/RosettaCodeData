import Foundation

//All rooms in cave
var cave: [Int:[Int]] = [
    1: [2, 3, 4],
    2: [1, 5, 6],
    3: [1, 7, 8],
    4: [1, 9, 10],
    5: [2, 9, 11],
    6: [2, 7, 12],
    7: [3, 6, 13],
    8: [3, 10, 14],
    9: [4, 5, 15],
    10: [4, 8, 16],
    11: [5, 12, 17],
    12: [6, 11, 18],
    13: [7, 14, 18],
    14: [8, 13, 19],
    15: [9, 16, 17],
    16: [10, 15, 19],
    17: [11, 20, 15],
    18: [12, 13, 20],
    19: [14, 16, 20],
    20: [17, 18, 19]
]

// initialize curr room, wumpus's room, bats room
var player: Int = 0, wumpus: Int = 0, bat1:Int = 0, bat2:Int = 0, pit1:Int = 0, pit2:Int = 0

//number of arrows left
var arrows = 5

//check if room is empty
func isEmpty(r:Int)->Bool {
    if r != player &&
       r != wumpus &&
       r != bat1 &&
       r != bat2 &&
       r != pit1 &&
       r != pit2 {
            return true
        }
        return false
}

//sense if theres bat/pit/wumpus in adjacent rooms
func sense(adj: [Int]) {
    var bat = false
    var pit = false
    for ar in adj {
        if ar == wumpus {
            print("You smell something terrible nearby.")
        }
        switch ar {
        case bat1, bat2:
            if !bat {
                print("You hear rustling.")
                bat = true
            }
        case pit1, pit2:
            if !pit {
                print("You feel a cold wind blowing from a nearby cavern.")
                pit = true
            }
        default:
            print("")
        }
    }
}

//check if there are more than 1 arrow then add plural to arrow message
func plural(n: Int)->String {
    if n != 1 {
        return "s"
    }
    return ""
}


func game() {

    //set current room to 1, start the game
    player = 1

    //wumpus, bats, pits will be in a random room - except start room
    wumpus = Int.random(in: 2..<21)
    bat1 = Int.random(in: 2..<21)

    //bat2 must be in different room to bat1
    while true {
        bat2 = Int.random(in: 2..<21)
        if bat2 != bat1 {
            break
        }
    }

    //pit1 and pit2 must be in different rooms from bats and each other
    while true {
        pit1 = Int.random(in: 2..<21)
        if pit1 != bat1 && pit1 != bat2 {
            break
        }
    }
    while true {
        pit2 = Int.random(in: 0..<21)
        if pit2 != bat1 && pit2 != bat2 && pit2 != pit1 {
            break
        }
    }

    //player session
    while true {
        print("\nYou are in room \(player) with \(arrows) arrow\(plural(n: arrows)) left\n")

        //list of adjacent rooms
        let adj = cave[player]!
        print("The adjacent rooms are \(adj)\n")

        //check adjacent rooms
        sense(adj: adj)

        //variable to keep track of next room player gonna choose
        var room: Int?
        while true {
            print("Choose an adjacent room: ")

            //validate the room player choose
            if let roomInput = Int(readLine()!) {
                room = roomInput
                if !adj.contains(room!) {
                    print("\ninvalid response, try again\n")
                    print("The adjacent rooms are \(adj)\n")
                } else {
                    break
                }
            } else {
                print("\ninvalid response, try again\n")
                print("The adjacent rooms are \(adj)\n")
            }
        }

        //initialize variable to store user input/action(shoot or walk)
        var action: String = ""

        //player action
        while true {
            print("Walk or shoot w/s: ")
            //validate the action player choose
            if var reply = readLine() {
                reply = reply.lowercased()
                if reply.count != 1 || (reply.count == 1 && Array(reply)[0] != "w" && Array(reply)[0] != "s") {
                    print("Invalid response, try again")
                } else {
                    //if valid store the action
                    action = Array(arrayLiteral: reply)[0]
                    break
                }
            } else {
                print("Invalid response, try again")
            }
        }

        if action == "w" {
            //if walk, set current room to selected room
            player = room!
            switch player {
                //if the selected room is wumpus/pit, player lose
                case wumpus:
                    print("You have been eaten by the wumpus and lost the game")
                    return
                case pit1, pit2:
                    print("You have fallen down a bottomless pit and lost the game!")
                    return
                //if the room has bat, player got transport to a random empty room
                case bat1, bat2:
                    while true {
                        room = Int.random(in: 2..<21)
                        if isEmpty(r: room!) {
                            print("A bat has transported you to a random empty room.")
                            player = room!
                            break
                        }
                    }
                default:
                    break
            }
        } else {
            //if player shoot to wumpus room, player win
            if room == wumpus {
                print("You have killed the wumpus and won the game!!")
                return
            } else {
                //chance player will miss the room with wumpus, wumpus will move to a different room
                let chance = Int.random(in: 0..<4)
                if chance > 0 {
                    wumpus = cave[wumpus]![Int.random(in: 0..<3)]
                    //if the room is the player room, player lost
                    if player == wumpus {
                        print("You have been eaten by the wumpus and lost the game!")
                        return
                    }
                }
            }
            //reduce arrow after shoot
            arrows-=1
            if arrows == 0 {
                print("You have run out of arrows and lost the game!")
                return
            }
        }
    }
}
game()
