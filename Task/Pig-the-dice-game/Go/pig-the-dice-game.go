package main

import (
	"fmt"
	"math/rand"
	"strings"
	"time"
)

func main() {
	rand.Seed(time.Now().UnixNano()) //Set seed to current time

	playerScores := [...]int{0, 0}
	turn := 0
	currentScore := 0

	for {
		player := turn % len(playerScores)

		fmt.Printf("Player %v [%v, %v], (H)old, (R)oll or (Q)uit: ", player,
			playerScores[player], currentScore)

		var answer string
		fmt.Scanf("%v", &answer)
		switch strings.ToLower(answer) {
		case "h": //Hold
			playerScores[player] += currentScore
			fmt.Printf("    Player %v now has a score of %v.\n\n", player, playerScores[player])

			if playerScores[player] >= 10 {
				fmt.Printf("    Player %v wins!!!\n", player)
				return
			}

			currentScore = 0
			turn += 1
		case "r": //Roll
			roll := rand.Intn(6) + 1

			if roll == 1 {
				fmt.Printf("    Rolled a 1. Bust!\n\n")
				currentScore = 0
				turn += 1
			} else {
				fmt.Printf("    Rolled a %v.\n", roll)
				currentScore += roll
			}
		case "q": //Quit
			return
		default: //Incorrent input
			fmt.Print("  Please enter one of the given inputs.\n")
		}
	}
	fmt.Printf("Player %v wins!!!\n", (turn-1)%len(playerScores))
}
