let testHands = [
	"2♥ 2♦ 2♣ k♣ q♦",
	"2♥ 5♥ 7♦ 8♣ 9♠",
	"a♥ 2♦ 3♣ 4♣ 5♦",
	"2♥ 3♥ 2♦ 3♣ 3♦",
	"2♥ 7♥ 2♦ 3♣ 3♦",
	"2♥ 7♥ 7♦ 7♣ 7♠",
	"10♥ j♥ q♥ k♥ a♥",
	"4♥ 4♠ k♠ 5♦ 10♠",
	"q♣ 10♣ 7♣ 6♣ 4♣",
	"joker 4♣ k♣ 5♦ 10♠",
	"joker 2♦ 2♠ k♠ q♦",
	"joker 3♥ 2♦ 3♠ 3♦",
	"joker 7♥ 7♦ 7♠ 7♣",
	"joker 2♦ joker 4♠ 5♠",
	"joker 2♠ joker a♠ 10♠",
	"joker q♦ joker a♦ 10♦"
];
	
for(hand of testHands) console.log(hand + ": " + analyzeHand(hand));
