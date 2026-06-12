// Define enums for card features
const Number = {
  ONE: 'ONE',
  TWO: 'TWO',
  THREE: 'THREE'
};

const Colour = {
  GREEN: 'GREEN',
  RED: 'RED',
  PURPLE: 'PURPLE'
};

const Shading = {
  OPEN: 'OPEN',
  SOLID: 'SOLID',
  STRIPED: 'STRIPED'
};

const Shape = {
  DIAMOND: 'DIAMOND',
  OVAL: 'OVAL',
  SQUIGGLE: 'SQUIGGLE'
};

// Card class
class Card {
  constructor(number, colour, shading, shape) {
    this.number = number;
    this.colour = colour;
    this.shading = shading;
    this.shape = shape;
  }

  toString() {
    return `[${this.number} ${this.colour} ${this.shading} ${this.shape}]`;
  }
}

// Create a pack of all possible cards
function createPackOfCards() {
  const pack = [];
  Object.values(Number).forEach(number => {
    Object.values(Colour).forEach(colour => {
      Object.values(Shading).forEach(shading => {
        Object.values(Shape).forEach(shape => {
          pack.push(new Card(number, colour, shading, shape));
        });
      });
    });
  });
  return pack;
}

// Check if three cards form a valid set
function isGameSet(triple) {
  const numbers = triple.map(card => card.number);
  const colours = triple.map(card => card.colour);
  const shadings = triple.map(card => card.shading);
  const shapes = triple.map(card => card.shape);

  return allSameOrAllDifferent(numbers) &&
         allSameOrAllDifferent(colours) &&
         allSameOrAllDifferent(shadings) &&
         allSameOrAllDifferent(shapes);
}

// Check if features are all the same or all different
function allSameOrAllDifferent(features) {
  const uniqueFeatures = new Set(features);
  return uniqueFeatures.size === 1 || uniqueFeatures.size === 3;
}

// Generate all combinations of a specific size from a list
function combinations(list, choose) {
  const result = [];
  const combination = Array.from({ length: choose }, (_, i) => i);

  while (combination[choose - 1] < list.length) {
    // Add current combination
    result.push(combination.map(i => list[i]));

    // Generate next combination
    let temp = choose - 1;
    while (temp !== 0 && combination[temp] === list.length - choose + temp) {
      temp -= 1;
    }
    combination[temp] += 1;
    for (let i = temp + 1; i < choose; i++) {
      combination[i] = combination[i - 1] + 1;
    }
  }

  return result;
}

// Fisher-Yates shuffle algorithm
function shuffleArray(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

// Main function
function main() {
  const pack = createPackOfCards();
  const cardCounts = [4, 8, 12];

  cardCounts.forEach(cardCount => {
    const shuffledPack = [...shuffleArray(pack)];
    const deal = shuffledPack.slice(0, cardCount);

    console.log(`Cards dealt: ${cardCount}`);
    deal.forEach(card => console.log(card.toString()));
    console.log();

    console.log("Sets found: ");
    const combos = combinations(deal, 3);
    combos.forEach(combo => {
      if (isGameSet(combo)) {
        console.log(combo.map(card => card.toString()).join(" "));
      }
    });
    console.log("-------------------------\n");
  });
}

// Run the program
main();
