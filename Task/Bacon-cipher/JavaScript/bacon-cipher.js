// Map for encoding characters to Baconian A/B sequences
const codes = {
    'a': "AAAAA", 'b': "AAAAB", 'c': "AAABA", 'd': "AAABB", 'e': "AABAA",
    'f': "AABAB", 'g': "AABBA", 'h': "AABBB", 'i': "ABAAA", 'j': "ABAAB",
    'k': "ABABA", 'l': "ABABB", 'm': "ABBAA", 'n': "ABBAB", 'o': "ABBBA",
    'p': "ABBBB", 'q': "BAAAA", 'r': "BAAAB", 's': "BAABA", 't': "BAABB",
    'u': "BABAA", 'v': "BABAB", 'w': "BABBA", 'x': "BABBB", 'y': "BBAAA",
    'z': "BBAAB",
    ' ': "BBBAA",  // use ' ' to denote any non-letter in the plaintext
};

// Create a reverse map for decoding A/B sequences back to characters
const decodeMap = {};
for (const key in codes) {
    if (codes.hasOwnProperty(key)) {
        decodeMap[codes[key]] = key;
    }
}

/**
 * Encodes plaintext into a sequence of A/B using Baconian cipher,
 * then embeds this sequence by casing letters in the message (cover text).
 * A is represented by lowercase, B by uppercase. Non-letter characters
 * in the plaintext are encoded as spaces.
 *
 * @param {string} plainText The secret message to hide.
 * @param {string} message The cover text in which to hide the secret message.
 * @returns {string} The steganographic message with the plaintext hidden in casing.
 */
function baconEncode(plainText, message) {
    // 1. Convert plaintext to A/B sequence
    const pt = plainText.toLowerCase();
    let encodedAB = '';
    for (const char of pt) {
        if (char >= 'a' && char <= 'z') {
            encodedAB += codes[char];
        } else {
            encodedAB += codes[' ']; // Encode non-letters as space
        }
    }

    // 2. Embed A/B sequence into the message by changing letter case
    const mg = message.toLowerCase(); // The Go code iterates over the lowercased message
    let result = '';
    let encodedIndex = 0; // Index for the encodedAB sequence

    for (let i = 0; i < mg.length; i++) {
        const lowerChar = mg[i]; // Character from the lowercased message

        if (lowerChar >= 'a' && lowerChar <= 'z') { // If the lowercased character is a letter
            if (encodedIndex < encodedAB.length) { // If there are still A/B bits to embed
                const abBit = encodedAB[encodedIndex];
                if (abBit === 'A') {
                    result += lowerChar; // Use lowercase for 'A'
                } else { // abBit === 'B'
                    result += lowerChar.toUpperCase(); // Use uppercase for 'B'
                }
                encodedIndex++; // Move to the next A/B bit
            } else {
                 // No more bits to embed, append the lowercased letter as is
                result += lowerChar;
            }
        } else {
            // If the lowercased character is not a letter, append it as is.
            // Note: This means any original uppercase non-letters or punctuation
            // will appear as their lowercased selves in the output if they
            // appear within the portion of the message used for embedding,
            // replicating the Go code's behavior.
            result += lowerChar;
        }
    }

    // The Go code stops iterating the message once the encodedAB is fully consumed.
    // The current JS loop iterates through the *entire* mg.
    // Let's adjust the JS loop to match the Go 'break' logic.
    // Re-implementing the second loop to match Go's `for _, c := range mg`
    // with the break condition `if count == len(et) { break }`.
    // Go's range on a string iterates over runes, but for ASCII letters it's 1:1 with bytes/chars.
    // The Go code appends bytes. Let's use an array and join at the end for exact match.

    let resultChars = [];
    encodedIndex = 0; // Reset index
    // Iterate over the ORIGINAL message string to correctly handle non-letters *after* embedding is done
    for (let i = 0; i < message.length; i++) {
        const originalChar = message[i];
        const lowerOriginalChar = originalChar.toLowerCase();

        if (lowerOriginalChar >= 'a' && lowerOriginalChar <= 'z') { // If it's a letter (case-insensitive check)
            if (encodedIndex < encodedAB.length) { // If there are still A/B bits to embed
                const abBit = encodedAB[encodedIndex];
                if (abBit === 'A') {
                    resultChars.push(lowerOriginalChar); // Use lowercase for 'A'
                } else { // abBit === 'B'
                    resultChars.push(lowerOriginalChar.toUpperCase()); // Use uppercase for 'B'
                }
                encodedIndex++; // Move to the next A/B bit
            } else {
                // No more bits to embed, append the *original* character
                resultChars.push(originalChar);
            }
        } else {
            // If it's not a letter, append the *original* character as is
            resultChars.push(originalChar);
        }
         // Go code's break condition: Stop after embedding all bits
         if (encodedIndex === encodedAB.length) {
            // Append the rest of the original message
            for (let j = i + 1; j < message.length; j++) {
                 resultChars.push(message[j]);
            }
            break; // Exit the loop early
         }
    }

     // If the encodedAB sequence is longer than the number of letters in the message,
     // the Go code's loop would finish without embedding all bits. The JS code
     // should also stop after processing all letters in the message that *could* be used.
     // The above revised loop handles this by breaking.

    return resultChars.join(''); // Join the array of characters into a string
}

/**
 * Decodes a message encoded with Baconian cipher by extracting A/B
 * sequences from letter casing (lowercase=A, uppercase=B) and
 * converting them back to characters.
 *
 * @param {string} message The steganographic message.
 * @returns {string} The hidden plaintext message.
 */
function baconDecode(message) {
    // 1. Extract the A/B sequence from letter casing
    let extractedAB = '';
    for (const char of message) {
        if (char >= 'a' && char <= 'z') {
            extractedAB += 'A'; // Lowercase means 'A'
        } else if (char >= 'A' && char <= 'Z') {
            extractedAB += 'B'; // Uppercase means 'B'
        }
        // Non-letter characters are ignored for decoding
    }

    // 2. Convert A/B sequence back to characters
    let decodedText = '';
    // Process the A/B sequence in 5-bit chunks
    for (let i = 0; i < extractedAB.length; i += 5) {
        const quintet = extractedAB.substring(i, i + 5); // Get the 5-character chunk
        const decodedChar = decodeMap[quintet]; // Look up the chunk in the reverse map

        if (decodedChar !== undefined) {
            decodedText += decodedChar; // Append the found character
        } else {
             // Optional: Handle unknown quintets, though the decodeMap should cover all encoded possibilities
             // For simplicity, replicating Go's behavior of just skipping if not found.
             // console.warn(`Unknown quintet: ${quintet}`);
        }
    }

    return decodedText;
}

// Main execution logic
function main() {
    const plainText = "the quick brown fox jumps over the lazy dog";
    const message = "bacon's cipher is a method of steganography created by francis bacon." +
        "this task is to implement a program for encryption and decryption of " +
        "plaintext using the simple alphabet of the baconian cipher or some " +
        "other kind of representation of this alphabet (make anything signify anything). " +
        "the baconian alphabet may optionally be extended to encode all lower " +
        "case characters individually and/or adding a few punctuation characters " +
        "such as the space.";

    const cipherText = baconEncode(plainText, message);
    console.log("Cipher text ->\n\n" + cipherText + "\n");

    const decodedText = baconDecode(cipherText);
    console.log("\nHidden text ->\n\n" + decodedText + "\n");
}

// Execute the main function
main();
