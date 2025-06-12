class ADFGVX {
    /** The WWI German ADFGVX cipher. */
    constructor(spoly, k, alph = 'ADFGVX') {
        this.polybius = spoly.toUpperCase().split('');
        this.pdim = Math.floor(Math.sqrt(this.polybius.length));
        this.key = k.toUpperCase().split('');
        this.keylen = this.key.length;
        this.alphabet = alph.split('');
        const pairs = [];
        for (let i = 0; i < this.alphabet.length; i++) {
            for (let j = 0; j < this.alphabet.length; j++) {
                pairs.push(this.alphabet[i] + this.alphabet[j]);
            }
        }
        this.encode = {};
        for (let i = 0; i < this.polybius.length; i++) {
            this.encode[this.polybius[i]] = pairs[i];
        }
        this.decode = {};
        for (const k in this.encode) {
            this.decode[this.encode[k]] = k;
        }
    }

    encrypt(msg) {
        /** Encrypt with the ADFGVX cipher. */
        const chars = [];
        for (const c of msg.toUpperCase()) {
            if (this.polybius.includes(c)) {
                chars.push(this.encode[c]);
            }
        }
        const flatChars = chars.join('').split('');
        const colvecs = [];
        for (let i = 0; i < this.keylen; i++) {
            const currentCol = [];
            for (let j = i; j < flatChars.length; j += this.keylen) {
                currentCol.push(flatChars[j]);
            }
            colvecs.push([this.key[i], currentCol]);
        }

        colvecs.sort((a, b) => a[0].localeCompare(b[0]));

        let result = '';
        for (const a of colvecs) {
            result += a[1].join('');
        }
        return result;
    }

    decrypt(cod) {
        /** Decrypt with the ADFGVX cipher. Does not depend on spacing of encoded text */
        const chars = [];
        for (const c of cod) {
            if (this.alphabet.includes(c)) {
                chars.push(c);
            }
        }

        const sortedkey = [...this.key].sort();
        const order = [];
        for (const ch of sortedkey) {
            order.push(this.key.indexOf(ch));
        }
        const originalorder = [];
        for (const ch of this.key) {
            originalorder.push(sortedkey.indexOf(ch));
        }

        const base = Math.floor(chars.length / this.keylen);
        const extra = chars.length % this.keylen;
        const strides = order.map((_, i) => base + (extra > i ? 1 : 0));
        const starts = [0];
        let sum = 0;
        for (let i = 0; i < strides.length - 1; i++) {
            sum += strides[i];
            starts.push(sum);
        }
        const ends = starts.map((start, i) => start + strides[i]);
        const cols = originalorder.map(i => chars.slice(starts[i], ends[i]));

        const pairs = [];
        for (let i = 0; i < Math.floor((chars.length - 1) / this.keylen) + 1; i++) {
            for (let j = 0; j < this.keylen; j++) {
                if (i * this.keylen + j < chars.length) {
                    pairs.push(cols[j][i]);
                }
            }
        }

        let decoded = '';
        for (let i = 0; i < pairs.length; i += 2) {
            decoded += this.decode[pairs[i] + pairs[i + 1]];
        }
        return decoded;
    }
}

// Helper function to shuffle an array (Fisher-Yates shuffle)
function shuffle(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}


async function main() {
    const PCHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.split('');
    shuffle(PCHARS);
    const POLYBIUS = PCHARS.join('');

    // Simulate reading from unixdict.txt (replace with your actual file reading method if needed)
    // For demonstration purposes, using a hardcoded word list:
    const WORDS = ['ABDEFGHIK', 'JLMNOPQRS', 'TUVWXYZ01', '23456789'];
    const KEY = WORDS[Math.floor(Math.random() * WORDS.length)];


    const SECRET = new ADFGVX(POLYBIUS, KEY);
    const MESSAGE = 'ATTACKAT1200AM';

    console.log(`Polybius: ${POLYBIUS}, key: ${KEY}`);
    console.log('Message: ', MESSAGE);

    const ENCODED = SECRET.encrypt(MESSAGE);
    const DECODED = SECRET.decrypt(ENCODED);

    console.log('Encoded: ', ENCODED);
    console.log('Decoded: ', DECODED);
}

main();
