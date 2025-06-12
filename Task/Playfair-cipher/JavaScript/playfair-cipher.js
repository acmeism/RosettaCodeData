const readline = require('readline');

// Enum-like object for Playfair options
const playfairOption = {
    NO_Q: 0,
    I_EQUALS_J: 1,
};

// Represents the Playfair cipher state and methods
class Playfair {
    constructor(keyword, pfo) {
        this.keyword = keyword;
        this.pfo = pfo; // playfairOption
        this.table = Array(5).fill(null).map(() => Array(5).fill('')); // 5x5 table
    }

    // Initializes the 5x5 Playfair table based on the keyword and option
    init() {
        const used = Array(26).fill(false); // Track used letters
        if (this.pfo === playfairOption.NO_Q) {
            used['Q'.charCodeAt(0) - 65] = true; // Q is used/omitted
        } else {
            used['J'.charCodeAt(0) - 65] = true; // J is used/replaced by I
        }

        const alphabet = this.keyword.toUpperCase() + "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        let row = 0;
        let col = 0;

        for (const char of alphabet) {
            const charCode = char.charCodeAt(0);

            // Check if it's a letter A-Z
            if (charCode >= 'A'.charCodeAt(0) && charCode <= 'Z'.charCodeAt(0)) {
                const charIndex = charCode - 65; // 0-25 index

                // Handle J if I_EQUALS_J option is selected
                let charToUse = char;
                let indexToUse = charIndex;
                if (char === 'J' && this.pfo === playfairOption.I_EQUALS_J) {
                    charToUse = 'I';
                    indexToUse = 'I'.charCodeAt(0) - 65;
                }

                // Skip Q if NO_Q option is selected
                if (charToUse === 'Q' && this.pfo === playfairOption.NO_Q) {
                     continue;
                }


                if (!used[indexToUse]) {
                    this.table[row][col] = charToUse;
                    used[indexToUse] = true;
                    col++;
                    if (col === 5) {
                        row++;
                        if (row === 5) {
                            break; // Table filled
                        }
                        col = 0;
                    }
                }
            }
        }
    }

    // Prepares the plaintext: uppercase, removes non-letters,
    // handles Q/J based on option, inserts X between duplicate letters,
    // pads with X/Z if length is odd.
    getCleanText(plainText) {
        plainText = plainText.toUpperCase();
        const cleanChars = [];
        let prevChar = ''; // Use '' to indicate no previous character

        for (let i = 0; i < plainText.length; i++) {
            let currentChar = plainText[i];
            const charCode = currentChar.charCodeAt(0);

            // Skip non-letters
            if (charCode < 'A'.charCodeAt(0) || charCode > 'Z'.charCodeAt(0)) {
                continue;
            }

            // Handle J if I_EQUALS_J option is specified, replace J with I
            if (currentChar === 'J' && this.pfo === playfairOption.I_EQUALS_J) {
                currentChar = 'I';
            }

            // Skip Q if NO_Q option is specified (already handled in init, but good here too)
             if (currentChar === 'Q' && this.pfo === playfairOption.NO_Q) {
                 continue;
             }


            // Insert 'X' between duplicate consecutive letters
            // Only compare if prevChar is set (not the very first character)
            if (prevChar !== '' && currentChar === prevChar) {
                cleanChars.push('X');
            }

            cleanChars.push(currentChar);
            prevChar = currentChar; // Store the character *after* potential X insertion
        }

        // If length is odd, add a padding character
        if (cleanChars.length % 2 === 1) {
            // Add 'X' unless the last letter is 'X', then add 'Z'
            if (cleanChars[cleanChars.length - 1] !== 'X') {
                cleanChars.push('X');
            } else {
                cleanChars.push('Z');
            }
        }

        return cleanChars.join('');
    }

    // Finds the row and column of a character in the table
    findChar(char) {
        for (let i = 0; i < 5; i++) {
            for (let j = 0; j < 5; j++) {
                if (this.table[i][j] === char) {
                    return [i, j]; // Return [row, col]
                }
            }
        }
        return [-1, -1]; // Should not happen if getCleanText is correct
    }

    // Encodes plaintext using the Playfair cipher
    encode(plainText) {
        const cleanText = this.getCleanText(plainText);
        const cipherChars = [];

        for (let i = 0; i < cleanText.length; i += 2) {
            const char1 = cleanText[i];
            const char2 = cleanText[i + 1]; // cleanText length is always even
            const [row1, col1] = this.findChar(char1);
            const [row2, col2] = this.findChar(char2);

            let encodedChar1, encodedChar2;

            if (row1 === row2) { // Same row
                encodedChar1 = this.table[row1][(col1 + 1) % 5];
                encodedChar2 = this.table[row2][(col2 + 1) % 5];
            } else if (col1 === col2) { // Same column
                encodedChar1 = this.table[(row1 + 1) % 5][col1];
                encodedChar2 = this.table[(row2 + 1) % 5][col2];
            } else { // Different row and column (rectangle)
                encodedChar1 = this.table[row1][col2];
                encodedChar2 = this.table[row2][col1];
            }

            cipherChars.push(encodedChar1);
            cipherChars.push(encodedChar2);

            // Add space after each digram, matching Go's output format
             if (i + 2 < cleanText.length) {
                 cipherChars.push(' ');
             }
        }

        return cipherChars.join('');
    }

    // Decodes ciphertext using the Playfair cipher
    decode(cipherText) {
        // The Go code processes the ciphertext including spaces,
        // stepping by 3. We'll do the same by stripping spaces first
        // and then processing in pairs. This is conceptually simpler in JS.
        // Or, we can replicate the Go loop that steps by 3. Let's replicate for exact match.
        const decodedChars = [];
        const l = cipherText.length;

        for (let i = 0; i < l; i += 3) { // Step by 3 due to spaces in encoded text
            const char1 = cipherText[i];
            const char2 = cipherText[i + 1];
            // cipherText[i+2] will be a space, which findChar will correctly not find (-1, -1)
            // But the Go code explicitly finds the *bytes* at i and i+1. Let's stick to that.

            // Ensure we only process valid character pairs
            if (!char1 || !char2 || char1 === ' ' || char2 === ' ') {
                // This shouldn't happen with the i+=3 loop structure if the input
                // format from encode is followed, but good to be safe.
                continue;
            }


            const [row1, col1] = this.findChar(char1);
            const [row2, col2] = this.findChar(char2);

            let decodedChar1, decodedChar2;

            // Decoding rules are the reverse of encoding
            if (row1 === row2) { // Same row
                // Shift left: (col - 1 + 5) % 5
                decodedChar1 = this.table[row1][(col1 + 4) % 5];
                decodedChar2 = this.table[row2][(col2 + 4) % 5];
            } else if (col1 === col2) { // Same column
                 // Shift up: (row - 1 + 5) % 5
                decodedChar1 = this.table[(row1 + 4) % 5][col1];
                decodedChar2 = this.table[(row2 + 4) % 5][col2];
            } else { // Different row and column (rectangle)
                decodedChar1 = this.table[row1][col2];
                decodedChar2 = this.table[row2][col1];
            }

            decodedChars.push(decodedChar1);
            decodedChars.push(decodedChar2);

             // Add space after each digram in decoded text, matching Go's output format
             if (i + 3 < l) { // Check if there's more content after the current digram+space
                  decodedChars.push(' ');
             }
        }

        return decodedChars.join('');
    }

    // Prints the 5x5 table to the console
    printTable() {
        console.log("The table to be used is :\n");
        for (let i = 0; i < 5; i++) {
            console.log(this.table[i].join(' ')); // Join row elements with space
        }
        console.log(); // Add a blank line for spacing
    }
}

// Main execution function using async/await for readline
async function main() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    const question = (query) => new Promise((resolve) => rl.question(query, resolve));

    try {
        const keyword = await question("Enter Playfair keyword : ");

        let ignoreQ = '';
        while (ignoreQ !== "y" && ignoreQ !== "n") {
            ignoreQ = (await question("Ignore Q when building table  y/n : ")).toLowerCase();
        }

        const pfo = (ignoreQ === "y") ? playfairOption.NO_Q : playfairOption.I_EQUALS_J;

        const pf = new Playfair(keyword, pfo);
        pf.init();
        pf.printTable();

        const plainText = await question("\nEnter plain text : ");

        const encodedText = pf.encode(plainText);
        console.log("\nEncoded text is :", encodedText);

        // The Go code decodes the encoded text *including* the spaces it added.
        // Pass the encoded text as is to the decode function.
        const decodedText = pf.decode(encodedText);
        console.log("Decoded text is :", decodedText);

    } finally {
        rl.close(); // Close the readline interface
    }
}

// Execute the main function
main();
