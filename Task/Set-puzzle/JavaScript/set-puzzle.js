// Constants
const number = ["1", "2", "3"];
const color = ["red", "green", "purple"];
const shade = ["solid", "open", "striped"];
const shape = ["oval", "squiggle", "diamond"];

// Card class
class Card {
  constructor(value) {
    this.value = value;
  }

  toString() {
    return `${number[Math.floor(this.value/27)]} ${color[Math.floor(this.value/9)%3]} ${shade[Math.floor(this.value/3)%3]} ${shape[this.value%3]}`;
  }
}

// Shuffle an array
function shuffle(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
}

// Main game function
function game(level, cards, sets) {
  // Create deck
  const deck = [];
  for (let i = 0; i < 81; i++) {
    deck.push(new Card(i));
  }

  let found = [];
  while (found.length !== sets) {
    found = [];

    // Deal
    shuffle(deck);

    // Consider all triplets
    for (let i = 2; i < cards; i++) {
      const c1 = deck[i];
      for (let j = 1; j < i; j++) {
        const c2 = deck[j];

        outer: for (let k = 0; k < j; k++) {
          const c3 = deck[k];

          // Check if it's a set
          for (let f = 1; f < 81; f *= 3) {
            if ((Math.floor(c1.value/f)%3 + Math.floor(c2.value/f)%3 + Math.floor(c3.value/f)%3) % 3 !== 0) {
              continue outer; // not a set
            }
          }

          // It's a set
          found.push([c1, c2, c3]);
        }
      }
    }
  }

  // Output results
  console.log(`${level} game. ${cards} cards, ${sets} sets.`);
  console.log("Cards:");
  for (let i = 0; i < cards; i++) {
    console.log("  ", deck[i].toString());
  }

  console.log("Sets:");
  for (const set of found) {
    console.log(`  ${set[0]}\n  ${set[1]}\n  ${set[2]}`);
  }
}

// Run the games
function main() {
  // Set random seed with current time
  Math.random();

  game("Basic", 9, 4);
  game("Advanced", 12, 6);
}

main();
