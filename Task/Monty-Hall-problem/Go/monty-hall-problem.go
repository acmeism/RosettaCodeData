package main

import (
    "fmt"
    "math/rand"
)

func main() {
    games := 1000000
    var switchWinsCar, keepWinsCar int
    for i := 0; i < games; i++ {
        // simulate game
        carDoor := rand.Intn(3)
        firstChoice := rand.Intn(3)
        var hostOpens int
        if carDoor == firstChoice {
            hostOpens = rand.Intn(2)
            if hostOpens >= carDoor {
                hostOpens++
            }
        } else {
            hostOpens = 3 - carDoor - firstChoice
        }
        remainingDoor := 3 - hostOpens - firstChoice

        // some assertions that above code produced a valid game state
        if carDoor < 0 || carDoor > 2 {
            panic("car behind invalid door")
        }
        if firstChoice < 0 || firstChoice > 2 {
            panic("contestant chose invalid door")
        }
        if hostOpens < 0 || hostOpens > 2 {
            panic("host opened invalid door")
        }
        if hostOpens == carDoor {
            panic("host opened door with car")
        }
        if hostOpens == firstChoice {
            panic("host opened contestant's first choice")
        }
        if remainingDoor < 0 || remainingDoor > 2 {
            panic("remaining door invalid")
        }
        if remainingDoor == firstChoice {
            panic("remaining door same as contestant's first choice")
        }
        if remainingDoor == hostOpens {
            panic("remaining door same as one host opened")
        }

        // tally results
        if firstChoice == carDoor {
            keepWinsCar++
        }
        if remainingDoor == carDoor {
            switchWinsCar++
        }
    }
    fmt.Println("In", games, "games,")
    fmt.Println("switching doors won the car", switchWinsCar, "times,")
    fmt.Println("keeping same door won the car", keepWinsCar, "times.")
}
