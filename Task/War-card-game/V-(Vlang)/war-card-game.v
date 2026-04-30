import rand
import rand.seed

const suits = ["♣", "♦", "♥", "♠"]
const faces = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"]

fn build_cards_and_ranks() ([]string, []int) {
    mut cards := []string{len: 52}
    mut ranks := []int{len: 52}
    for i in 0 .. 52 {
        cards[i] = faces[i % 13] + suits[i / 13]
        ranks[i] = i % 13
    }
    return cards, ranks
}

fn war() {
    cards, ranks := build_cards_and_ranks()
    mut deck := []int{len: 52}
    mut hand1 := []int{cap: 52}
    mut hand2 := []int{cap: 52}
  mut played1, mut played2 := []int{}, []int{}
  mut card1, mut card2, mut num_played := 0, 0, 0
    for ial in 0 .. 52 {
        deck[ial] = ial
    }
    rand.shuffle(mut deck) or { panic("shuffle failed") }
    // distribute cards
    for i in 0 .. 26 {
        hand1.insert(0, deck[2 * i])
        hand2.insert(0, deck[2 * i + 1])
    }
    for hand1.len > 0 && hand2.len > 0 {
        card1 = hand1[0]
        hand1.delete(0)
        card2 = hand2[0]
        hand2.delete(0)
        played1 = [card1]
        played2 = [card2]
        num_played = 2
        for {
            print("${cards[card1]}\t${cards[card2]}\t")
            if ranks[card1] > ranks[card2] {
                hand1 << played1
                hand1 << played2
                println("Player 1 takes the $num_played cards. Now has ${hand1.len}.")
                break
            }
      else if ranks[card1] < ranks[card2] {
                hand2 << played2
                hand2 << played1
                println("Player 2 takes the $num_played cards. Now has ${hand2.len}.")
                break
            }
      else {
                println("War!")
                if hand1.len < 2 {
                    println("Player 1 has insufficient cards left.")
                    hand2 << played2
                    hand2 << played1
                    hand2 << hand1
                    hand1.clear()
                    break
                }
                if hand2.len < 2 {
                    println("Player 2 has insufficient cards left.")
                    hand1 << played1
                    hand1 << played2
                    hand1 << hand2
                    hand2.clear()
                    break
                }
                fd_card1 := hand1[0] // face down card
                card1 = hand1[1]     // face up card
                hand1.delete(0)
                hand1.delete(0)
                played1 << fd_card1
                played1 << card1
        // do again for other
                fd_card2 := hand2[0] // face down card
                card2 = hand2[1]     // face up card
                hand2.delete(0)
                hand2.delete(0)
                played2 << fd_card2
                played2 << card2
        // other finished
                num_played += 4
                println("? \t? \tFace down cards.")
            }
        }
    }

    if hand1.len == 52 { println("Player 1 wins the game!") }
  else { println("Player 2 wins the game!") }
}

fn main() {
  seeds := seed.time_seed_array(2)
  rand.seed(seeds)
    war()
}
