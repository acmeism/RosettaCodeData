foreach hand {
   "2♥ 2♦ 2♣ k♣ q♦" "2♥ 5♥ 7♦ 8♣ 9♠" "a♥ 2♦ 3♣ 4♣ 5♦" "2♥ 3♥ 2♦ 3♣ 3♦"
   "2♥ 7♥ 2♦ 3♣ 3♦" "2♥ 7♥ 7♦ 7♣ 7♠" "10♥ j♥ q♥ k♥ a♥" "4♥ 4♠ k♠ 5♦ 10♠"
   "q♣ 10♣ 7♣ 6♣ 4♣"
} {
    puts "${hand}: [PokerHandAnalyser::analyse $hand]"
}
