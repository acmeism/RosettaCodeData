// Equivalent data structures for Java's arrays and map
const nums = [
    "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
    "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
];

const tens = ["zero", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"];

// Map for irregular ordinal endings (like Java's static initializer block)
const ordinalMap = {
    "one": "first",
    "two": "second",
    "three": "third",
    "five": "fifth",
    "eight": "eighth",
    "nine": "ninth",
    "twelve": "twelfth"
    // Note: twenty, thirty, etc. are handled by the 'y' -> 'ieth' rule
};

/**
 * Recursive helper function to convert a number to its cardinal English spelling.
 * Handles positive integers up to quintillions.
 * Note: JavaScript numbers are 64-bit floats (IEEE 754). Integers are safe up to
 * Number.MAX_SAFE_INTEGER (2^53 - 1, approx 9 quadrillion). Very large numbers
 * beyond this might lose precision or require BigInt. The test cases provided
 * fit within the safe integer range.
 * @param {number} n - The number to convert.
 * @returns {string} The English spelling of the number.
 */
function numToStringHelper(n) {
    if (n < 0) {
        // Handle negative numbers recursively
        return "negative " + numToStringHelper(-n);
    }
    if (n <= 19) {
        // Numbers 0-19 directly from the nums array
        return nums[n];
    }
    if (n <= 99) {
        // Numbers 20-99: combine tens place and (optionally) ones place
        // Use Math.floor for integer division equivalent
        const ten = tens[Math.floor(n / 10)];
        const rest = n % 10;
        return ten + (rest > 0 ? "-" + numToStringHelper(rest) : "");
    }

    let label = "";
    let factor = 0;

    // Determine the scale (hundred, thousand, million, etc.)
    // Using number literals for factors
    if (n <= 999) {
        label = "hundred";
        factor = 100;
    } else if (n <= 999999) {
        label = "thousand";
        factor = 1000;
    } else if (n <= 999999999) {
        label = "million";
        factor = 1000000;
    } else if (n <= 999999999999) {
        label = "billion";
        factor = 1000000000; // 1e9
    } else if (n <= 999999999999999) {
        label = "trillion";
        factor = 1000000000000; // 1e12
    } else if (n <= 999999999999999999) { // Approaching JS safe integer limit
        label = "quadrillion";
        factor = 1000000000000000; // 1e15
    } else { // Numbers beyond this may need BigInt for perfect accuracy
        label = "quintillion";
        factor = 1000000000000000000; // 1e18
    }

    // Recursively spell the parts
    // Use Math.floor for integer division equivalent
    const highPart = numToStringHelper(Math.floor(n / factor));
    const lowPart = n % factor;

    return highPart + " " + label + (lowPart > 0 ? " " + numToStringHelper(lowPart) : "");
}

/**
 * Converts a number to its cardinal English spelling (e.g., 123 -> "one hundred twenty-three").
 * Public facing function that calls the helper.
 * @param {number} n - The number to convert.
 * @returns {string} The English spelling of the number.
 */
function numToString(n) {
    // Ensure input is a number
    n = Number(n);
    // Handle the base case of 0 explicitly for clarity, though helper handles it.
    if (n === 0) {
        return nums[0]; // "zero"
    }
    return numToStringHelper(n);
}


/**
 * Converts a number to its ordinal English spelling (e.g., 1 -> "first", 123 -> "one hundred twenty-third").
 * @param {number} n - The number to convert.
 * @returns {string} The ordinal English spelling.
 */
function toOrdinal(n) {
    // Get the cardinal spelling first
    const spelling = numToString(n);

    // Split the spelling into words
    const parts = spelling.split(' ');

    // Get the last word, which determines the ordinal ending
    const lastWord = parts[parts.length - 1];

    let replacement = "";

    // Check if the last word is hyphenated (e.g., "twenty-three")
    if (lastWord.includes('-')) {
        const lastSplit = lastWord.split('-'); // ["twenty", "three"]
        const base = lastSplit[0]; // "twenty"
        const lastPart = lastSplit[1]; // "three"
        let ordinalLastPart = "";

        // Apply ordinal rules to the part after the hyphen
        if (ordinalMap.hasOwnProperty(lastPart)) {
            ordinalLastPart = ordinalMap[lastPart]; // irregular: three -> third
        } else if (lastPart.endsWith('y')) {
            // This case shouldn't happen after a hyphen (e.g., "sixty-twenty"),
            // but included for robustness matching the Java code.
             ordinalLastPart = lastPart.slice(0, -1) + "ieth";
        } else {
            ordinalLastPart = lastPart + "th"; // regular: four -> fourth
        }
        replacement = `${base}-${ordinalLastPart}`; // "twenty-third"

    } else {
        // Handle non-hyphenated last words
        if (ordinalMap.hasOwnProperty(lastWord)) {
            replacement = ordinalMap[lastWord]; // irregular: one -> first, two -> second
        } else if (lastWord.endsWith('y')) {
            replacement = lastWord.slice(0, -1) + "ieth"; // twenty -> twentieth, thirty -> thirtieth
        } else {
            replacement = lastWord + "th"; // seven -> seventh, hundred -> hundredth
        }
    }

    // Replace the last word in the parts array
    parts[parts.length - 1] = replacement;

    // Join the parts back together
    return parts.join(' ');
}

// --- Main execution / Testing ---
// Equivalent to the Java main method's test loop
const testNumbers = [0, 1, 2, 3, 4, 5, 11, 12, 13, 19, 20, 21, 22, 23, 65, 99, 100, 101, 272, 23456, 8007006005004003];

console.log("--- Ordinal Number Spelling (JavaScript) ---");
testNumbers.forEach(test => {
    // Use template literals for easy string formatting
    console.log(`${test} = ${toOrdinal(test)}`);
});
