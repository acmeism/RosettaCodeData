// ADFGVX Cipher Implementation in JavaScript

// Cipher squares
const squareRosetta = [ // from Rosetta Code
  ['A', 'B', 'C', 'D', 'E'],
  ['F', 'G', 'H', 'I', 'K'],
  ['L', 'M', 'N', 'O', 'P'],
  ['Q', 'R', 'S', 'T', 'U'],
  ['V', 'W', 'X', 'Y', 'Z'],
  ['J', '1', '2', '3', '4']
];

const squareWikipedia = [ // from Wikipedia
  ['B', 'G', 'W', 'K', 'Z'],
  ['Q', 'P', 'N', 'D', 'S'],
  ['I', 'O', 'A', 'X', 'E'],
  ['F', 'C', 'L', 'U', 'M'],
  ['T', 'H', 'Y', 'V', 'R'],
  ['J', '1', '2', '3', '4']
];

// Test text strings
const textRosetta = "0ATTACKATDAWN";
const textRosettaEncoded = "DQBDAXDQPDQH"; // only for test
const textWikipedia = "FLEEATONCE";
const textWikipediaEncoded = "UAEOLWRINS"; // only for test
const textTest = "The invasion will start on the first of January";
const textTestEncoded = "RASOAQXFIOORXESXADETSWLTNIAZQOISBRGBALY"; // only for test

// Coordinate class (equivalent to koord struct in Go)
class Coord {
  constructor(x, y) {
    this.x = x;
    this.y = y;
  }

  lessThan(other) {
    if (this.y > other.y) {
      return false;
    }
    if (this.y < other.y) {
      return true;
    }
    if (this.x < other.x) {
      return true;
    }
    return false;
  }

  equalTo(other) {
    return this.x === other.x && this.y === other.y;
  }
}

// Convert square to encryption and decryption maps
function squareToMaps(square) {
  const encryptMap = new Map();
  const decryptMap = new Map();

  for (let x = 0; x < square.length; x++) {
    for (let y = 0; y < square[x].length; y++) {
      const value = square[x][y];
      const coord = new Coord(x, y);

      // For encryption map, use character as key
      encryptMap.set(value, coord);

      // For decryption map, use coordinate string as key
      // (JavaScript Maps can't use objects as keys directly, so convert to string)
      decryptMap.set(`${x},${y}`, value);
    }
  }

  return { encryptMap, decryptMap };
}

// Remove spaces and non-valid characters
function removeSpace(text, encryptMap) {
  const upper = text.toUpperCase().replace(/\s/g, '');
  let result = '';

  for (const char of upper) {
    if (encryptMap.has(char)) {
      result += char;
    }
  }

  return result;
}

// Replace 'J' with 'I' (for specific Polybius square implementations)
function removeSpaceI(text) {
  const upper = text.toUpperCase();
  let result = '';

  for (const char of upper) {
    // Use only ASCII characters from A to Z
    if (char >= 'A' && char <= 'Z') {
      result += char === 'J' ? 'I' : char;
    }
  }

  return result;
}

// Encrypt using ADFGVX cipher
function encrypt(text, encryptMap, decryptMap) {
  text = removeSpace(text, encryptMap);

  const row0 = [];
  const row1 = [];

  // Get coordinates for each character
  for (const char of text) {
    const coord = encryptMap.get(char);
    row0.push(coord.x);
    row1.push(coord.y);
  }

  // Combine coordinates
  const combined = [...row0, ...row1];

  let result = '';
  // Convert pairs of coordinates back to characters
  for (let i = 0; i < combined.length; i += 2) {
    const key = `${combined[i]},${combined[i+1]}`;
    result += decryptMap.get(key);
  }

  return result;
}

// Decrypt using ADFGVX cipher
function decrypt(text, encryptMap, decryptMap) {
  text = removeSpace(text, encryptMap);

  const coords = [];

  // Get coordinates for each character
  for (const char of text) {
    coords.push(encryptMap.get(char));
  }

  // Extract x and y values
  const flatCoords = [];
  for (const coord of coords) {
    flatCoords.push(coord.x);
    flatCoords.push(coord.y);
  }

  const half = Math.floor(flatCoords.length / 2);
  const firstHalf = flatCoords.slice(0, half);
  const secondHalf = flatCoords.slice(half);

  let result = '';

  // Recombine coordinates to get original text
  for (let i = 0; i < firstHalf.length; i++) {
    const key = `${firstHalf[i]},${secondHalf[i]}`;
    result += decryptMap.get(key);
  }

  return result;
}

// Main function to test
function main() {
  // Test with Rosetta square
  let { encryptMap, decryptMap } = squareToMaps(squareRosetta);

  console.log("From Rosetta Code");
  console.log("original:\t", textRosetta);
  let encoded = encrypt(textRosetta, encryptMap, decryptMap);
  console.log("encoded:\t", encoded);
  let decoded = decrypt(encoded, encryptMap, decryptMap);
  console.log("and back:\t", decoded);

  // Test with Wikipedia square
  ({ encryptMap, decryptMap } = squareToMaps(squareWikipedia));

  console.log("\nFrom Wikipedia");
  console.log("original:\t", textWikipedia);
  encoded = encrypt(textWikipedia, encryptMap, decryptMap);
  console.log("encoded:\t", encoded);
  decoded = decrypt(encoded, encryptMap, decryptMap);
  console.log("and back:\t", decoded);

  // Test with longer text
  console.log("\nFrom Rosetta Code (longer text)");
  console.log("original:\t", textTest);
  encoded = encrypt(textTest, encryptMap, decryptMap);
  console.log("encoded:\t", encoded);
  // Note: If the text has an odd number of letters, the algorithm doesn't work!
  decoded = decrypt(encoded, encryptMap, decryptMap);
  console.log("and back:\t", decoded);
}

// Run the main function
main();
