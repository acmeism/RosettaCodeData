const INT_TO_WORD = {
    '0': 'zero', '1': 'one', '2': 'two', '3': 'three', '4': 'four',
    '5': 'five', '6': 'six', '7': 'seven', '8': 'eight', '9': 'nine',
    '10': 'ten', '11': 'eleven', '12': 'twelve', '13': 'thirteen',
    '14': 'fourteen', '15': 'fifteen', '16': 'sixteen',
    '17': 'seventeen', '18': 'eighteen', '19': 'nineteen',
    '20': 'twenty', '30': 'thirty', '40': 'forty', '50': 'fifty',
    '60': 'sixty', '70': 'seventy', '80': 'eighty', '90': 'ninety'
};

const WORD_TO_INT = {
    'zero': 0, 'single': 1, 'one': 1, 'two': 2, 'three': 3,
    'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8,
    'nine': 9, 'ten': 10, 'eleven': 11, 'twelve': 12,
    'thirteen': 13, 'fourteen': 14, 'fifteen': 15, 'sixteen': 16,
    'seventeen': 17, 'eighteen': 18, 'nineteen': 19, 'twenty': 20,
    'thirty': 30, 'forty': 40, 'fifty': 50, 'sixty': 60,
    'seventy': 70, 'eighty': 80, 'ninety': 90
};

function words2Num(words) {
    const wordList = words.toLowerCase().split(/[-\s]+/);
    if (wordList.length > 2) {
        throw new Error(
            `Cannot yet parse number words of greater than 2 words. ${wordList.join(', ')} is too long.`
        );
    }
    let num = 0;
    for (const w of wordList) {
        num += WORD_TO_INT[w];
    }
    return num;
}

const LETTER_CHARS = 'abcdefghijklmnopqrstuvwxyz';
const PUNCTUATION_CHARS = ',-\'.!';

const CHAR_TO_WORD = {};
for (const letter of LETTER_CHARS) {
    CHAR_TO_WORD[letter] = letter;
}
Object.assign(CHAR_TO_WORD, {
    ',': 'comma',
    '-': 'hyphen',
    '\'': 'apostrophe',
    '.': 'period',
    // below inconsistent with above but used to validate Sallow's autogram
    // with punctuation from Hofstadter's 1982 "Metamagical Themas"
    '!': '!'
});

const WORD_TO_CHAR = {};
for (const letter of LETTER_CHARS) {
    WORD_TO_CHAR[letter] = letter;
}
Object.assign(WORD_TO_CHAR, {
    'comma': ',',
    'hyphen': '-',
    'apostrophe': '\'',
    'period': '.',
    '!': '!'
});

function findCountsAndChars(sentence, includePunctuation = false) {
    /**
     * Uses regex to match descriptions of a number of characters.
     * E.g. "Twenty-two t's", "five b", "thirty one s"
     * Only works for numbers < 100
     */

    // number words that can stand on their own.
    // e.g. 'two', 'thirteen', 'thirty', ...
    const singleWordNumbers = Object.keys(WORD_TO_INT);

    // number words that come before others. e.g. 'twenty', 'fifty', ...
    const leadingWordNumbers = Object.keys(WORD_TO_INT).filter(word => WORD_TO_INT[word] >= 20);

    const leadingWordOr = leadingWordNumbers.join('|');
    const singleWordOr = singleWordNumbers.join('|');

    // 0 or 1 of (leading word followed by a '-' or whitespace),
    // followed by one single word
    const numberRe = `(?<number>(?:(?:${leadingWordOr})[-\\s]?)?(?:${singleWordOr}))`;

    let punctuationRe = '';
    if (includePunctuation) {
        const punctuationOr = Object.keys(WORD_TO_CHAR)
            .filter(word => !LETTER_CHARS.includes(word))
            .join('|');
        punctuationRe = punctuationOr + '|';
    }

    // one char from a-z, followed by 0 or 1 of "'" only if that's
    // followed by an 's', followed by 0 or 1 's'
    const charRe = `(?<character>(?:${punctuationRe}[a-z]){1})'?(?=s)?s?`;

    // find a word break, followed by a number word match,
    // followed by whitespace, followed by a character match
    const numberCharRe = `\\b${numberRe}\\s${charRe}`;

    const regex = new RegExp(numberCharRe, 'g');
    const matches = [];
    let match;
    while ((match = regex.exec(sentence.toLowerCase())) !== null) {
        matches.push([match.groups.number, match.groups.character]);
    }
    return matches;
}

function validate(sentence, includePunctuation = false, verbose = false) {
    /**
     * Returns true if sentence is an autogram
     */
    const sentenceLower = sentence.toLowerCase();
    let countableChars = LETTER_CHARS;
    if (includePunctuation) {
        countableChars += PUNCTUATION_CHARS;
    }

    const counts = {};
    for (const char of countableChars) {
        const count = (sentenceLower.match(new RegExp(char.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g')) || []).length;
        if (count > 0) {
            counts[char] = count;
        }
    }

    // find sentence char counts
    const countsAndChars = findCountsAndChars(sentenceLower, includePunctuation);

    // create dictionary of character counts as described by sentence
    const sentenceCounts = {};
    for (const match of countsAndChars) {
        const numMatch = match[0];
        const charMatch = match[1];
        sentenceCounts[WORD_TO_CHAR[charMatch]] = words2Num(numMatch);
    }

    if (verbose) {
        console.log(`Regex matches: ${JSON.stringify(countsAndChars)}`);
        console.log(`Parsed sentence counts: ${JSON.stringify(sentenceCounts)}`);
        console.log(`Function counts: ${JSON.stringify(counts)}`);
    }

    // compare function counts to sentence counts
    let valid = true;
    for (const char in counts) {
        if (char in sentenceCounts) {
            const sc = sentenceCounts[char];
            delete sentenceCounts[char];
            if (counts[char] === sc) {
                if (verbose) console.log(`${char}: ${sc} verified`);
            } else {
                valid = false;
                console.log(`${char}: INVALID. True count: ${counts[char]}, Sentence says: ${sc}.`);
            }
        } else {
            valid = false;
            console.log(`${char}: Missing from sentence. True count: ${counts[char]}.`);
        }
    }

    // any remaining characters that were mentioned by the sentence
    // but somehow not found in the function counts mean the function
    // didn't pick up on something it should've
    if (Object.keys(sentenceCounts).length > 0) {
        throw new Error(
            `Sentence mentions ${Object.keys(sentenceCounts).length} chars that were not found by validate().\n${JSON.stringify(sentenceCounts)}`
        );
    }

    return valid;
}

function runValidationTests() {
    // first element is sentence, second is whether punctuation is counted
    const sentences = [
        // 1
        [`This sentence employs two a's, two c's, two d's, twenty-eight e's,
        five f's, three g's, eight h's, eleven i's, three l's, two m's,
        thirteen n's, nine o's, two p's, five r's, twenty-five s's,
        twenty-three t's, six v's, ten w's, two x's, five y's, and one z.`, false],
        // 2
        [`This sentence employs two a's, two c's, two d's, twenty eight e's,
        five f's, three g's, eight h's, eleven i's, three l's, two m's, thirteen n's,
        nine o's, two p's, five r's, twenty five s's, twenty three t's, six v's,
        ten w's, two x's, five y's, and one z.`, false],
        // 3
        [`Only the fool would take trouble to verify that his sentence was
        composed of ten a's, three b's, four c's, four d's, forty-six e's,
        sixteen f's, four g's, thirteen h's, fifteen i's, two k's, nine l's,
        four m's, twenty-five n's, twenty-four o's, five p's, sixteen r's,
        forty-one s's, thirty-seven t's, ten u's, eight v's, eight w's, four x's,
        eleven y's, twenty-seven commas, twenty-three apostrophes, seven hyphens
        and, last but not least, a single !`, true],
        // 4
        [`This pangram contains four as, one b, two cs, one d, thirty es, six fs,
        five gs, seven hs, eleven is, one j, one k, two ls, two ms, eighteen ns,
        fifteen os, two ps, one q, five rs, twenty-seven ss, eighteen ts, two us,
        seven vs, eight ws, two xs, three ys, & one z.`, false],
        // 5
        [`This sentence contains one hundred and ninety-seven letters: four a's,
        one b, three c's, five d's, thirty-four e's, seven f's, one g, six h's,
        twelve i's, three l's, twenty-six n's, ten o's, ten r's, twenty-nine s's,
        nineteen t's, six u's, seven v's, four w's, four x's, five y's,
        and one z.`, false],
        // 6
        [`Thirteen e's, five f's, two g's, five h's, eight i's, two l's,
        three n's, six o's, six r's, twenty s's, twelve t's, three u's, four v's,
        six w's, four x's, two y's.`, false],
        // 7
        [`Fifteen e's, seven f's, four g's, six h's, eight i's, four n's,
        five o's, six r's, eighteen s's, eight t's, four u's, three v's, two w's,
        three x's.`, true],
        // 8
        [`Sixteen e's, five f's, three g's, six h's, nine i's, five n's,
        four o's, six r's, eighteen s's, eight t's, three u's, three v's, two w's,
        four z's.`, false]
    ];

    for (let i = 0; i < sentences.length; i++) {
        console.log(`\n----------------- sentence ${i + 1} -----------------`);
        const isValid = validate(
            sentences[i][0],
            sentences[i][1],
            false
        );
        console.log(isValid ? 'Valid!' : 'Invalid!');
    }
}

// Run the tests
runValidationTests();
