const readline = require("readline");
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});
const crypto = require("crypto");

const dictionaryUrl = "http://wiki.puzzlers.org/pub/wordlists/unixdict.txt";
const wordRegexPattern = /^[a-z]{3,}$/m;
let dictionary = undefined;

function askQuestion(query) {
    return new Promise(resolve => rl.question(query, resolve));
}

function askInt(query) {
    return new Promise(resolve => rl.question(query, answer => resolve(parseInt(answer, 10))));
}

async function loadWebDictionary(url) {
    try {
        const response = await fetch(url);
        if (!response.ok)
            throw new Error(`HTTP ERROR -- ${response.status}`);

        const rawText = await response.text();
        const wordList = rawText.split("\n")
            .map(str => {
                const match = str.match(wordRegexPattern);
                return match ? match[0] : null;
            })
            .filter(word => word !== null);
        return wordList;
    } catch (err) {
        console.error("Failed to load dictionary", err.message);
        return [];
    }
}

function zip(arr0, arr1) {
    return arr0.map((el, idx) => [el, arr1[idx]]);
}

function* cycle(arr) {
    let index = 0;
    while (true) {
        yield arr[index];
        index = (index + 1) % arr.length;
    }
}

function counter(arr) {
    const countMap = {};
    for (const item of arr)
        countMap[item] = (countMap[item] || 0) + 1;
    return countMap;
}

function subtractCounters(c0, c1) {
    const result = {...c0};

    for (const [key, count] of Object.entries(c1))
        if (result[key]) {
            result[key] -= count;
            if (result[key] <= 0) {
                delete result[key];
            }
        }

    return result;
}

function subtractSets(s0, s1) {
    const result = new Set();
    for (const item of s0)
        if (!s1.has(item))
            result.add(item);
    return result;
}

function isWordiff(wordiffs, word, dict) {
    const current = wordiffs[wordiffs.length-1];

    if (!dict.includes(word))
        return false;
    if (wordiffs.includes(word))
        return false;

    if (word.length < current.length)
        return isWordiffRemoval(word, current);
    else if (word.length > current.length)
        return isWordiffInsertion(word, current);
    return isWordiffChange(word, current);
}

function isWordiffRemoval(word, previous) {
    const possible = new Set();
    for (let i = 0; i < previous.length; i++)
        possible.add(previous.slice(0, i)+previous.slice(i+1));
    return possible.has(word);
}

function isWordiffInsertion(word, previous) {
    const diff = subtractCounters(counter(word), counter(previous));
    const diffCount = Object.values(diff).reduce((a, v) => a + v, 0);
    if (diffCount !== 1)
        return false;

    const insert = Object.keys(diff)[0];
    const possible = new Set();
    for (let i = 0; i < previous.length + 1; i++)
        possible.add(previous.slice(0, i)+insert+previous.slice(i));
    return possible.has(word);
}

function isWordiffChange(word, previous) {
    const diffCount = zip(word.split(""), previous.split(""))
        .map(([a, b]) => a !== b ? 1 : 0)
        .reduce((a, v) => a + v, 0);
    return diffCount === 1;
}

function couldHaveEntered(wordiffs, dict, limit=10) {
    const currentSet = new Set(wordiffs);
    const dictSet = new Set(dict);
    const remaining = subtractSets(dictSet, currentSet);
    const currentLength = wordiffs[wordiffs.length-1].length;
    const possibleLengths = [currentLength-1, currentLength, currentLength+1];
    const filteredRemaining = Array.from(remaining).filter(word => possibleLengths.includes(word.length));
    const suggestions = [];
    for (const candidate of filteredRemaining)
        if (isWordiff(wordiffs, candidate, dict)) {
            suggestions.push(candidate);
            if (suggestions.length >= limit)
                break;
        }
    return suggestions;
}

async function main() {
    dictionary = await loadWebDictionary(dictionaryUrl);
    console.log(`Loaded ${dictionary.length} words into dictionary.`);
    if (dictionary.length === 0) {
        rl.close();
        return;
    }

    const dict34 = dictionary.filter(word => word.length === 3 || word.length === 4);
    if (dict34.length === 0) {
        console.error("ERROR -- No valid 3 or 4 letter words found in the dictionary.");
        rl.close();
        return;
    }

    const startIndex = crypto.randomInt(dict34.length);
    let wordiffs = [dict34[startIndex]];

    const numberOfPlayers = await askInt("How many players (maximum 8)? ");
    if (numberOfPlayers > 8 || numberOfPlayers < 1) {
        console.error(`ERROR -- Must have between 1 and 8 players. Got ${numberOfPlayers}.`);
        rl.close();
        return;
    }

    const players = [];
    for (let i = 0; i < numberOfPlayers; i++) {
        const playerName = (await askQuestion(`  (${i+1}) Enter name: `)).trim();
        players.push(playerName || `Player${i+1}`);
    }

    const playersCycle = cycle(players);

    while (true) {
        let currentPlayer = playersCycle.next().value;

        console.log(`=== ${currentPlayer}'s turn! ===`);
        const currentWord = wordiffs[wordiffs.length-1];

        const word = (await askQuestion(
            `Current word is "${wordiffs.at(-1)}"\n`+
            "Enter your word: "
        )).trim().toLowerCase();

        if (isWordiff(wordiffs, word, dictionary)) {
            wordiffs.push(word);
            console.log(`Accepted! New chain: ${wordiffs.join(" -> ")}`);
        } else {
            const alternatives = couldHaveEntered(wordiffs, dictionary);
            console.log(
                `Game over, ${currentPlayer}!\n`+
                `You could have entered one of these words (first ${alternatives.length} suggestions): ${alternatives.join(", ")}`
            );
            break;
        }
    }

    rl.close();
}

main();
