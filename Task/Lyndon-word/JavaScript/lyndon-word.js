function main() {
  const alphabet = ["0", "1"];
  let word = alphabet[0];

  while (word !== "") {
    console.log(word);
    word = nextWord(5, word, alphabet);
  }
}

// Using the Duval (1988) algorithm
function nextWord(maxLength, word, alphabet) {
  // Step 1: Repeat the word and truncate
  let nextWord = word;
  while (nextWord.length < maxLength) {
    nextWord += word;
  }
  nextWord = nextWord.substring(0, maxLength);

  // Step 2: Remove last symbol of the next word if it is the last symbol in the alphabet
  const alphabetLastSymbol = alphabet[alphabet.length - 1];
  while (nextWord.endsWith(alphabetLastSymbol)) {
    nextWord = nextWord.substring(0, nextWord.length - 1);
  }

  // Step 3: Replace the last symbol of the next word by its successor in the alphabet
  if (nextWord !== "") {
    const wordLastSymbol = nextWord.substring(nextWord.length - 1);
    const index = alphabet.indexOf(wordLastSymbol) + 1;
    nextWord = nextWord.substring(0, nextWord.length - 1);
    nextWord += alphabet[index];
  }

  return nextWord;
}

// Execute the main function
main();
