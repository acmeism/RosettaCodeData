function nysiis(input) {
    // Convert to uppercase and keep only letters
    let s = input
        .split('')
        .filter(c => /^[A-Za-z]$/.test(c))
        .map(c => c.toUpperCase())
        .join('');

    if (s.length === 0) {
        return '';
    }

    // Helper function to replace a pattern at the beginning of a string
    function replaceAtStart(str, from, to) {
        if (str.startsWith(from)) {
            return { result: to + str.substring(from.length), changed: true };
        }
        return { result: str, changed: false };
    }

    // Helper function to replace multiple patterns at the beginning
    function multiReplaceAtStart(str, patterns, to) {
        for (const pattern of patterns) {
            if (str.startsWith(pattern)) {
                return { result: to + str.substring(pattern.length), changed: true };
            }
        }
        return { result: str, changed: false };
    }

    // Helper function to replace a pattern at the end of a string
    function replaceAtEnd(str, from, to) {
        if (str.endsWith(from)) {
            return { result: str.substring(0, str.length - from.length) + to, changed: true };
        }
        return { result: str, changed: false };
    }

    // Helper function to replace multiple patterns at the end
    function multiReplaceAtEnd(str, patterns, to) {
        for (const pattern of patterns) {
            if (str.endsWith(pattern)) {
                return { result: str.substring(0, str.length - pattern.length) + to, changed: true };
            }
        }
        return { result: str, changed: false };
    }

    // Helper function to check if character is vowel
    function isVowel(c) {
        return ['A', 'E', 'I', 'O', 'U'].includes(c);
    }

    // Step 1: Initial transformations
    let result = replaceAtStart(s, "MAC", "MCC");
    s = result.result;

    result = replaceAtStart(s, "KN", "NN");
    s = result.result;

    result = replaceAtStart(s, "K", "C");
    s = result.result;

    result = multiReplaceAtStart(s, ["PH", "PF"], "FF");
    s = result.result;

    result = replaceAtStart(s, "SCH", "SSS");
    s = result.result;

    // Step 2: Handle endings
    const suffix1 = ["EE", "IE"];
    const suffix2 = ["DT", "RT", "RD", "NT", "ND"];

    result = multiReplaceAtEnd(s, suffix1, "Y");
    if (result.changed) {
        s = result.result.substring(0, result.result.length - 1); // Remove the last character
    } else {
        result = multiReplaceAtEnd(s, suffix2, "D");
        if (result.changed) {
            s = result.result.substring(0, result.result.length - 1); // Remove the last character
        }
    }

    let out = '';
    const chars = s.split('');

    if (chars.length === 0) {
        return '';
    }

    // Add first character
    out += chars[0];

    // Process remaining characters
    for (let i = 1; i < chars.length; i++) {
        let currentChar = chars[i];
        const prevChar = chars[i - 1];
        const nextChar = i + 1 < chars.length ? chars[i + 1] : null;

        // Apply transformations
        if (currentChar === 'E' && nextChar === 'V') {
            // EV -> AV (but we're processing E, so make it A and let V be processed normally)
            currentChar = 'A';
        } else if (isVowel(currentChar)) {
            currentChar = 'A';
        }

        switch (currentChar) {
            case 'Q':
                currentChar = 'G';
                break;
            case 'Z':
                currentChar = 'S';
                break;
            case 'M':
                currentChar = 'N';
                break;
            case 'K':
                // Handle KN -> NN, otherwise K -> C
                if (nextChar === 'N') {
                    // This will be handled when we process N
                    currentChar = 'N';
                } else {
                    currentChar = 'C';
                }
                break;
            case 'H':
                // H is silent if not between vowels
                if (!isVowel(prevChar) || (nextChar === null || !isVowel(nextChar))) {
                    currentChar = prevChar;
                }
                break;
            case 'W':
                // W after vowel becomes A
                if (isVowel(prevChar)) {
                    currentChar = 'A';
                }
                break;
        }

        // Handle multi-character patterns
        if (i + 1 < chars.length) {
            const twoChar = chars[i] + chars[i + 1];
            switch (twoChar) {
                case "KN":
                    currentChar = 'N';
                    break;
                case "PH":
                    currentChar = 'F';
                    break;
            }
        }

        if (i + 2 < chars.length) {
            const threeChar = chars[i] + chars[i + 1] + chars[i + 2];
            if (threeChar === "SCH") {
                currentChar = 'S';
            }
        }

        // Only add if different from last character
        if (out[out.length - 1] !== currentChar) {
            out += currentChar;
        }
    }

    // Final cleanup
    if (out.endsWith('S')) {
        out = out.substring(0, out.length - 1);
    }

    if (out.length >= 2 && out.endsWith("AY")) {
        out = out.substring(0, out.length - 2) + "Y";
    }

    if (out.endsWith('A')) {
        out = out.substring(0, out.length - 1);
    }

    return out;
}

// Test cases
function runTests() {
    const testCases = [
        ["Bishop", "BASAP"],
        ["Carlson", "CARLSAN"],
        ["Carr", "CAR"],
        ["Chapman", "CAPNAN"],
        ["Franklin", "FRANCLAN"],
        ["Greene", "GRAN"],
        ["Harper", "HARPAR"],
        ["Jacobs", "JACAB"],
        ["Larson", "LARSAN"],
        ["Lawrence", "LARANC"],
        ["Lawson", "LASAN"],
        ["Louis, XVI", "LASXV"],
        ["Lynch", "LYNC"],
        // ["Mackenzie", "MCANSY"],
        ["Matthews", "MAT"],
        ["McCormack", "MCARNAC"],
        ["McDaniel", "MCDANAL"],
        ["McDonald", "MCDANALD"],
        ["Mclaughlin", "MCLAGLAN"],
        ["Morrison", "MARASAN"],
        ["O'Banion", "OBANAN"],
        ["O'Brien", "OBRAN"],
        ["Richards", "RACARD"],
        ["Silva", "SALV"],
        ["Watkins", "WATCAN"],
        ["Wheeler", "WALAR"],
        ["Willis", "WAL"],
        ["brown, sr", "BRANSR"],
        ["browne, III", "BRAN"],
        ["browne, IV", "BRANAV"],
        ["knight", "NAGT"],
        ["mitchell", "MATCAL"],
        ["o'daniel", "ODANAL"],
    ];

    console.log("Name             Code     Status");
    console.log("--------------------------------");

    for (const [name, expected] of testCases) {
        const code = nysiis(name);
        const status = code === expected ?
            "ok" :
            `ERROR: ${expected} expected`;
        console.log(`${name.padEnd(16)} ${code.padEnd(8)} ${status}`);
    }
}

// Run the tests
runTests();
