// MD5 Constants
const INITIAL_A = 0x67452301;
const INITIAL_B = 0xEFCDAB89; // No need for L suffix or static_cast
const INITIAL_C = 0x98BADCFE; // No need for L suffix or static_cast
const INITIAL_D = 0x10325476;

const SHIFT_AMOUNTS = [
    7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
    5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20,
    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
];

// K constants (T table) - Sine values
const K = [
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
];

/**
 * Left-rotate a 32-bit integer by a number of bits.
 * @param {number} x - The integer to rotate.
 * @param {number} n - The number of bits to rotate by.
 * @returns {number} The rotated integer.
 */
function rotl(x, n) {
    // Ensure x is treated as 32-bit for the shifts
    return ((x << n) | (x >>> (32 - n))) | 0;
}

/**
 * Converts a Uint8Array (byte array) to a hexadecimal string.
 * @param {Uint8Array} bytes - The byte array to convert.
 * @returns {string} The hexadecimal string representation.
 */
function bytesToHexString(bytes) {
    let hexString = "";
    for (const byte of bytes) {
        hexString += byte.toString(16).padStart(2, '0');
    }
    return hexString;
}

/**
 * Converts a string to a Uint8Array using UTF-8 encoding.
 * @param {string} text - The string to convert.
 * @returns {Uint8Array} The resulting byte array.
 */
function stringToBytes(text) {
    return new TextEncoder().encode(text);
}

/**
 * Computes the MD5 hash of a byte array.
 * @param {Uint8Array} message - The input message as a byte array.
 * @returns {Uint8Array} The 16-byte MD5 hash.
 */
function computeMD5(message) {
    const messageLengthBytes = message.length;
    const messageLengthBits = BigInt(messageLengthBytes) * 8n; // Use BigInt for potentially large lengths

    // Calculate padding length
    // Need (length + 1 + k) % 64 == 56 bytes (or 448 bits)
    // So, length + 1 + k = 64n + 56
    // k = 64n + 56 - length - 1
    // Minimum k is when 64n is just >= length + 1 - 56 + 1 = length - 54
    // Padding length includes the 0x80 byte and the 8 length bytes.
    // Total length must be multiple of 64 bytes (512 bits).
    const numBlocks = Math.ceil((messageLengthBytes + 1 + 8) / 64);
    const totalLength = numBlocks * 64;
    const paddingLength = totalLength - messageLengthBytes;

    // Create padded message buffer
    const paddedMessage = new Uint8Array(totalLength);
    paddedMessage.set(message); // Copy original message

    // Append the '1' bit (0x80 byte)
    paddedMessage[messageLengthBytes] = 0x80;

    // Append the 64-bit message length (little-endian)
    // Note: JavaScript bitwise ops work on 32 bits. Handle 64-bit length carefully.
    const lengthOffset = totalLength - 8;
    for (let i = 0; i < 8; ++i) {
        paddedMessage[lengthOffset + i] = Number((messageLengthBits >> (BigInt(i) * 8n)) & 0xFFn);
    }

    // Initialize hash state variables (ensure they are 32-bit ints)
    let a = INITIAL_A | 0;
    let b = INITIAL_B | 0;
    let c = INITIAL_C | 0;
    let d = INITIAL_D | 0;

    const buffer = new Array(16); // Reusable buffer for 16 words (32-bit integers)

    // Process the message in 64-byte (512-bit) blocks
    for (let i = 0; i < numBlocks; ++i) {
        const blockOffset = i * 64;

        // Prepare the 16-word buffer from the current block (little-endian)
        for (let j = 0; j < 16; ++j) {
            const wordIndex = blockOffset + j * 4;
            buffer[j] = (
                (paddedMessage[wordIndex]) |
                (paddedMessage[wordIndex + 1] << 8) |
                (paddedMessage[wordIndex + 2] << 16) |
                (paddedMessage[wordIndex + 3] << 24)
            ) | 0; // Ensure 32-bit integer
        }

        // Save current hash state
        let originalA = a;
        let originalB = b;
        let originalC = c;
        let originalD = d;

        // Main loop (64 rounds)
        for (let j = 0; j < 64; ++j) {
            let f, bufferIndex;
            const div16 = Math.floor(j / 16);

            switch (div16) {
                case 0: // Round 1: F = (B & C) | (~B & D)
                    f = (b & c) | (~b & d);
                    bufferIndex = j;
                    break;
                case 1: // Round 2: G = (B & D) | (C & ~D)
                    f = (b & d) | (c & ~d);
                    bufferIndex = (j * 5 + 1) % 16;
                    break;
                case 2: // Round 3: H = B ^ C ^ D
                    f = b ^ c ^ d;
                    bufferIndex = (j * 3 + 5) % 16;
                    break;
                case 3: // Round 4: I = C ^ (B | ~D)
                    f = c ^ (b | ~d);
                    bufferIndex = (j * 7) % 16;
                    break;
            }

             // Ensure intermediate results are 32-bit
            f = f | 0;
            const term1 = a | 0;
            const term2 = buffer[bufferIndex] | 0;
            const term3 = K[j] | 0;
            const shift = SHIFT_AMOUNTS[j]; // Use direct index j for SHIFT_AMOUNTS

            // Perform the round calculation: temp = B + rotl(A + F + M[g] + K[i], s)
            let sum = (term1 + f + term2 + term3) | 0;
            let rotatedSum = rotl(sum, shift);
            let temp = (b + rotatedSum) | 0;

            // Update hash variables
            a = d;
            d = c;
            c = b;
            b = temp;
        }

        // Add the original hash state back (with 32-bit wrap)
        a = (a + originalA) | 0;
        b = (b + originalB) | 0;
        c = (c + originalC) | 0;
        d = (d + originalD) | 0;
    }

    // Construct final 16-byte hash (little-endian)
    const md5Bytes = new Uint8Array(16);
    let count = 0;
    for (const word of [a, b, c, d]) {
        for (let i = 0; i < 4; ++i) {
            md5Bytes[count++] = (word >> (i * 8)) & 0xFF;
        }
    }

    return md5Bytes;
}

// --- Main execution (equivalent to C++ main) ---
const tests = [
    "",
    "a",
    "abc",
    "message digest",
    "abcdefghijklmnopqrstuvwxyz",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
];

console.log("MD5 Hashes:");
for (const test of tests) {
    const messageBytes = stringToBytes(test);
    const hashBytes = computeMD5(messageBytes);
    const hexHash = bytesToHexString(hashBytes);
    console.log(`${hexHash} <== "${test}"`);
}
