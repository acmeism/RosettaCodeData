const animals = [["fly", "I don't know why she swallowed a fly, perhaps she'll die."],
                 ["spider", "That wriggled and jiggled and tickled inside her."],
                 ["bird", "How absurd, to swallow a bird!"],
                 ["cat", "Fancy that, she swallowed a cat!"],
                 ["dog", "What a hog, to swallow a dog!"],
                 ["goat", "She opened her throat and swallowed a goat!"],
                 ["cow", "I don't know how she swallowed a cow."],
                 ["horse", "She's dead, of course!"]];

const n = animals.length;
for (let i = 0; i < n; i++) {
  console.log("There was an old lady who swallowed a " + animals[i][0]);
  console.log(animals[i][1]);
  if (i > 0 && i < (n - 1)) {
    for (let j = 0; j < i; j++) {
      console.log(`She swallowed the ${animals[i-j][0]} to catch the ${animals[i-j-1][0]}`);
    }
    console.log(animals[0][1]);
  }
}
