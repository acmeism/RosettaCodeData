const fs = require('fs');

fs.readFile("words.txt", "utf8", (err, data) => {
    if (err) {
        console.error("Error reading the file:", err);
        return;
    }

    const words = data.split(/\r?\n/); // This regex splits on both Unix and Windows line endings
    const wordSet = new Set(words);
    const seenWords = new Set();
    const wordList = [];

    for (let word of wordSet) {
        if (word.length > 6) {
            const reversedWord = word.split('').reverse().join('');
            const wordPair = `${word}:${reversedWord}`;
            const reversedWordPair = `${reversedWord}:${word}`;

            if (wordSet.has(reversedWord) && reversedWord !== word && !seenWords.has(reversedWordPair)) {
                wordList.push([word, reversedWord]);
                seenWords.add(wordPair); // Store seen words as a string pair to make it easy to check
            }
        }
    }

    console.log(wordList.length);

    wordList.sort((a, b) => a[0].localeCompare(b[0])).forEach(([word, reversedWord]) => {
        console.log(`${word.padStart(9)} ${reversedWord}`);
    });
});
