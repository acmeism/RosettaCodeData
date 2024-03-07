import "random" for Random
import "./queue" for Deque

var rand  = Random.new()
var suits = ["♣", "♦", "♥", "♠"]
var faces = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A" ]
var cards = List.filled(52, null)
for (i in 0..51) cards[i] = "%(faces[i%13])%(suits[(i/13).floor])"
var ranks = List.filled(52, 0)
for (i in 0..51) ranks[i] = i % 13

var war = Fn.new {
    var deck = List.filled(52, 0)
    for (i in 0..51) deck[i] = i
    rand.shuffle(deck)
    var hand1 = Deque.new()
    var hand2 = Deque.new()
    for (i in 0..25) {
        hand1.pushFront(deck[2*i])
        hand2.pushFront(deck[2*i+1])
    }
    while (hand1.count > 0 && hand2.count > 0) {
        var card1 = hand1.popFront()
        var card2 = hand2.popFront()
        var played1 = [card1]
        var played2 = [card2]
        var numPlayed = 2
        while (true) {
            System.write("%(cards[card1])\t%(cards[card2])\t")
            if (ranks[card1] > ranks[card2]) {
                hand1.pushAllBack(played1)
                hand1.pushAllBack(played2)
                System.print("Player 1 takes the %(numPlayed) cards. Now has %(hand1.count).")
                break
            } else if (ranks[card1] < ranks[card2]) {
                hand2.pushAllBack(played2)
                hand2.pushAllBack(played1)
                System.print("Player 2 takes the %(numPlayed) cards. Now has %(hand2.count).")
                break
            } else {
                System.print("War!")
                if (hand1.count < 2) {
                    System.print("Player 1 has insufficient cards left.")
                    hand2.pushAllBack(played2)
                    hand2.pushAllBack(played1)
                    hand2.pushAllBack(hand1)
                    hand1.clear()
                    break
                }
                if (hand2.count < 2) {
                    System.print("Player 2 has insufficient cards left.")
                    hand1.pushAllBack(played1)
                    hand1.pushAllBack(played2)
                    hand1.pushAllBack(hand2)
                    hand2.clear()
                    break
                }
                played1.add(hand1.popFront()) // face down card
                card1 = hand1.popFront()      // face up card
                played1.add(card1)
                played2.add(hand2.popFront()) // face down card
                card2 = hand2.popFront()      // face up card
                played2.add(card2)
                numPlayed = numPlayed + 4
                System.print("? \t? \tFace down cards.")
            }
        }
    }
    if (hand1.count == 52) {
        System.print("Player 1 wins the game!")
    } else {
        System.print("Player 2 wins the game!")
    }
}

war.call()
