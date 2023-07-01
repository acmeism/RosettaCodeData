import rand
import rand.seed
import os
fn main() {
	rand.seed(seed.time_seed_array(2)) //Set seed to current time

	mut player_scores := [0, 0]
	mut turn := 0
	mut current_score := 0

	for {
		player := turn % player_scores.len

		answer := os.input("Player $player [${player_scores[player]}, $current_score], (H)old, (R)oll or (Q)uit: ").to_lower()

		match answer {
            "h"{ //Hold
                player_scores[player] += current_score
                print("    Player $player now has a score of ${player_scores[player]}.\n")

                if player_scores[player] >= 100 {
                    println("    Player $player wins!!!")
                    return
                }

                current_score = 0
                turn += 1
            }
            "r"{ //Roll
                roll := rand.int_in_range(1, 7) or {1}

                if roll == 1 {
                    println("    Rolled a 1. Bust!\n")
                    current_score = 0
                    turn += 1
                } else {
                    println("    Rolled a ${roll}.")
                    current_score += roll
                }
            }
            "q"{ //Quit
                return
            }
            else{ //Incorrent input
                println("  Please enter one of the given inputs.")
            }
		}
	}
	println("Player ${(turn-1)%player_scores.len} wins!!!", )
}
