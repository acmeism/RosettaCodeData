// Returns true if strings s1 and s2 differ by one character.
function oneAway(s1, s2) {
    if (s1.length !== s2.length) return false;
    let diff = 0;
    for (let i = 0; i < s1.length; i++) {
        if (s1[i] !== s2[i]) {
            if (diff) return false;
            diff++;
        }
    }
    return diff === 1;
}

// Join a sequence of strings into a single string using the given separator.
function join(arr, separator) {
    return arr.join(separator);
}

// If possible, print the shortest chain of single-character modifications that
// leads from "from" to "to", with each intermediate step being a valid word.
// This is an application of breadth-first search.
function wordLadder(words, from, to) {
    const poss = words.get(from.length);
    if (poss) {
        const queue = [[from]];
        while (queue.length) {
            const curr = queue.shift();
            for (let i = 0; i < poss.length; i++) {
                const word = poss[i];
                if (!oneAway(word, curr[curr.length - 1])) continue;
                if (word === to) {
                    console.log(join(curr.concat(to), " -> "));
                    return true;
                }
                queue.push(curr.concat(word));
                poss.splice(i, 1);
                i--;
            }
        }
    }
    console.log(`${from} into ${to} cannot be done.`);
    return false;
}

// Main logic
async function main() {
    const words = new Map();
    // Assuming unixdict.txt is available as a text file
    // In a real Node.js environment, you would use fs.readFileSync or similar
    // For browser, you would fetch the file
    // Here, we simulate loading the dictionary
    const dictionary = [
        "boy", "man", "girl", "lady", "john", "jane", "child", "adult",
        "cat", "cot", "dot", "dog", "lead", "load", "goad", "gold",
        "white", "whale", "black", "blake", "bubble", "bubbly", "rubble", "tickle"
    ];
    for (const word of dictionary) {
        if (!words.has(word.length)) words.set(word.length, []);
        words.get(word.length).push(word);
    }

    wordLadder(words, "boy", "man");
    wordLadder(words, "girl", "lady");
    wordLadder(words, "john", "jane");
    wordLadder(words, "child", "adult");
    wordLadder(words, "cat", "dog");
    wordLadder(words, "lead", "gold");
    wordLadder(words, "white", "black");
    wordLadder(words, "bubble", "tickle");
}

// Uncomment to run in a Node.js environment
main();
