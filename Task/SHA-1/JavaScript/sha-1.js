class SHA1 {
    constructor() {
        // Constants
        this.BLOCK_LENGTH = 64; // Bytes
        this.H = [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0];
        this.K = [0x5a827999, 0x6ed9eba1, 0x8f1bbcdc, 0xca62c1d6];
    }

    /**
     * Rotates left (circular left shift) on a 32-bit number.
     * @param {number} n - The 32-bit number.
     * @param {number} bits - The number of bits to rotate.
     * @returns {number} The rotated 32-bit number.
     */
    _rotl(n, bits) {
        // Ensure n is treated as 32-bit for the shift operations
        return ((n << bits) | (n >>> (32 - bits))) | 0; // | 0 ensures result is 32-bit signed int
    }

    /**
     * Adds SHA-1 padding to the message bytes.
     * @param {Uint8Array} messageBytes - The message as bytes.
     * @returns {Uint8Array} The padded message bytes.
     */
    _addPadding(messageBytes) {
        const msgLenBytes = messageBytes.length;
        // Use BigInt for potentially large bit lengths
        const bitLength = BigInt(msgLenBytes) * 8n;

        // Calculate the total padded length in bytes
        // Need msgLenBytes + 1 (for 0x80) + k (zeros) + 8 (length) = N * 64
        // msgLenBytes + 9 + k = N * 64
        // The number of zero bytes 'k' needed is:
        // k = (64 - (msgLenBytes + 9) % 64) % 64
        const k = (this.BLOCK_LENGTH - ((msgLenBytes + 9) % this.BLOCK_LENGTH)) % this.BLOCK_LENGTH;
        const paddedLength = msgLenBytes + 1 + k + 8;
        const paddedBytes = new Uint8Array(paddedLength);

        // 1. Copy original message
        paddedBytes.set(messageBytes);

        // 2. Append a single '1' bit (0x80 byte)
        paddedBytes[msgLenBytes] = 0x80;

        // 3. Append K '0' bits (zero bytes). Uint8Array initializes to 0, so this is implicit.

        // 4. Append length L as a 64-bit big-endian integer.
        const lengthOffset = paddedLength - 8;
        for (let i = 0; i < 8; i++) {
            // Extract byte from BigInt bitLength
            const shift = BigInt(i) * 8n;
            // Place it in big-endian order (most significant byte first)
            paddedBytes[lengthOffset + 7 - i] = Number((bitLength >> shift) & 0xffn);
        }

        return paddedBytes;
    }

    /**
     * Computes the SHA-1 hash of a message string.
     * @param {string} message - The input message string.
     * @returns {string} The SHA-1 hash as a 40-character hex string.
     */
    messageDigest(message) {
        // 1. Convert message string to UTF-8 bytes
        const encoder = new TextEncoder(); // Assumes UTF-8
        const messageBytes = encoder.encode(message);

        // 2. Add padding
        const paddedBytes = this._addPadding(messageBytes);

        // 3. Initialize hash values
        let state = [...this.H]; // Create a working copy

        // 4. Process message in 64-byte (512-bit) blocks
        for (let i = 0; i < paddedBytes.length; i += this.BLOCK_LENGTH) {
            const blockBytes = paddedBytes.subarray(i, i + this.BLOCK_LENGTH);

            // Prepare the message schedule (80 32-bit words)
            const W = new Array(80);

            // a. Copy block into first 16 words (big-endian)
            for (let t = 0; t < 16; t++) {
                const offset = t * 4;
                W[t] = ((blockBytes[offset] << 24) |
                        (blockBytes[offset + 1] << 16) |
                        (blockBytes[offset + 2] << 8) |
                        (blockBytes[offset + 3])) | 0; // | 0 ensures 32-bit signed int
            }

            // b. Extend the first 16 words into the remaining 64 words
            for (let t = 16; t < 80; t++) {
                const wt = W[t - 3] ^ W[t - 8] ^ W[t - 14] ^ W[t - 16];
                W[t] = this._rotl(wt, 1);
            }

            // Initialize hash value for this block
            let a = state[0];
            let b = state[1];
            let c = state[2];
            let d = state[3];
            let e = state[4];

            // Main loop
            for (let t = 0; t < 80; t++) {
                let f, k;
                const round = Math.floor(t / 20);
                switch (round) {
                    case 0: // Rounds 0-19
                        f = (b & c) | (~b & d);
                        k = this.K[0];
                        break;
                    case 1: // Rounds 20-39
                        f = b ^ c ^ d;
                        k = this.K[1];
                        break;
                    case 2: // Rounds 40-59
                        f = (b & c) | (b & d) | (c & d);
                        k = this.K[2];
                        break;
                    case 3: // Rounds 60-79
                        f = b ^ c ^ d;
                        k = this.K[3];
                        break;
                }

                // Ensure all additions are performed modulo 2^32
                const temp = (this._rotl(a, 5) + f + e + k + W[t]) | 0;
                e = d;
                d = c;
                c = this._rotl(b, 30);
                b = a;
                a = temp;
            }

            // Add this block's hash to the result so far (modulo 2^32)
            state[0] = (state[0] + a) | 0;
            state[1] = (state[1] + b) | 0;
            state[2] = (state[2] + c) | 0;
            state[3] = (state[3] + d) | 0;
            state[4] = (state[4] + e) | 0;
        }

        // 5. Produce the final hash value (big-endian) as a hex string
        let hexHash = "";
        for (const h of state) {
             // Convert each 32-bit component to hex, padding with '0'
             // Use >>> 0 to treat h as unsigned before converting to hex parts
             const unsignedH = h >>> 0;
             hexHash += (unsignedH >>> 24).toString(16).padStart(2, '0');
             hexHash += ((unsignedH >>> 16) & 0xff).toString(16).padStart(2, '0');
             hexHash += ((unsignedH >>> 8) & 0xff).toString(16).padStart(2, '0');
             hexHash += (unsignedH & 0xff).toString(16).padStart(2, '0');
        }

        return hexHash;
    }
}

// --- Main execution (equivalent to C++ main) ---
const sha1 = new SHA1();
const message = "Rosetta Code";
const digest = sha1.messageDigest(message);
console.log(digest);
