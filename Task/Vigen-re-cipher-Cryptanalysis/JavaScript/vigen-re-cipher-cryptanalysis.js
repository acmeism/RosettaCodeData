// Encoded text
const encoded =
    "MOMUD EKAPV TQEFM OEVHP AJMII CDCTI FGYAG JSPXY ALUYM NSMYH" +
    "VUXJE LEPXJ FXGCM JHKDZ RYICU HYPUS PGIGM OIYHF WHTCQ KMLRD" +
    "ITLXZ LJFVQ GHOLW CUHLO MDSOE KTALU VYLNZ RFGBX PHVGA LWQIS" +
    "FGRPH JOOFW GUBYI LAPLA LCAFA AMKLG CETDW VOELJ IKGJB XPHVG" +
    "ALWQC SNWBU BYHCU HKOCE XJEYK BQKVY KIIEH GRLGH XEOLW AWFOJ" +
    "ILOVV RHPKD WIHKN ATUHN VRYAQ DIVHX FHRZV QWMWV LGSHN NLVZS" +
    "JLAKI FHXUF XJLXM TBLQV RXXHR FZXGV LRAJI EXPRV OSMNP KEPDT" +
    "LPRWM JAZPK LQUZA ALGZX GVLKL GJTUI ITDSU REZXJ ERXZS HMPST" +
    "MTEOE PAPJH SMFNB YVQUZ AALGA YDNMP AQOWT UHDBV TSMUE UIMVH" +
    "QGVRW AEFSP EMPVE PKXZY WLKJA GWALT VYYOB YIXOK IHPDS EVLEV" +
    "RVSGB JOGYW FHKBL GLXYA MVKIS KIEHY IMAPX UOISK PVAGN MZHPW" +
    "TTZPV XFCCD TUHJH WLAPF YULTB UXJLN SIJVV YOVDJ SOLXG TGRVO" +
    "SFRII CTMKO JFCQF KTINQ BWVHG TENLH HOGCS PSFPV GJOKM SIFPR" +
    "ZPAAS ATPTZ FTPPD PORRF TAXZP KALQA WMIUD BWNCT LEFKO ZQDLX" +
    "BUXJL ASIMR PNMBF ZCYLV WAPVF QRHZV ZGZEF KBYIO OFXYE VOWGB" +
    "BXVCB XBAWG LQKCM ICRRX MACUO IKHQU AJEGL OIJHH XPVZW JEWBA" +
    "FWAML ZZRXJ EKAHV FASMU LVVUT TGK";

// Standard English letter frequencies (normalized probabilities)
const freq = [
    0.08167, 0.01492, 0.02782, 0.04253, 0.12702, 0.02228, 0.02015,
    0.06094, 0.06966, 0.00153, 0.00772, 0.04025, 0.02406, 0.06749,
    0.07507, 0.01929, 0.00095, 0.05987, 0.06327, 0.09056, 0.02758,
    0.00978, 0.02360, 0.00150, 0.01974, 0.00074,
];

const A_CODE = 'A'.charCodeAt(0); // ASCII code for 'A'
const Z_CODE = 'Z'.charCodeAt(0); // ASCII code for 'Z'

// Helper function to calculate the sum of elements in an array
function sum(arr) {
    return arr.reduce((acc, val) => acc + val, 0);
}

// Finds the rotation (shift, 0-25) for a given frequency distribution
// 'arr' that best matches the standard English frequencies 'freq'.
// Uses a chi-squared-like measure for goodness of fit.
function bestMatch(arr) {
    const total = sum(arr);
    let bestFit = Infinity; // Use Infinity for a large initial value
    let bestRotate = 0;

    for (let rotate = 0; rotate < 26; rotate++) {
        let fit = 0.0;
        for (let i = 0; i < 26; i++) {
            const expectedFreq = freq[i];
            // Calculate normalized frequency for the current rotation
            const actualFreq = total > 0 ? arr[(i + rotate) % 26] / total : 0;
            const d = actualFreq - expectedFreq;
            // Chi-squared like goodness of fit: (observed - expected)^2 / expected
            // The Go code uses (actualFreq - expectedFreq)^2 / expectedFreq
            // This is a standard form of chi-squared contribution per bin.
            fit += (d * d) / expectedFreq;
        }

        if (fit < bestFit) {
            bestFit = fit;
            bestRotate = rotate;
        }
    }
    return bestRotate; // Return the best shift (0-25)
}

// Analyzes the frequency distribution of characters at intervals
// equal to the potential key length. It determines the best shift
// for each position in the key, populates `keyArray` with these
// shifts (0-25), and calculates an overall goodness-of-fit score
// for this key length against standard English frequencies.
function freqEveryNth(msg, keyArray) {
    const l = msg.length;
    const interval = keyArray.length; // This is the potential key length
    const out = Array(26).fill(0); // Temporary frequency count for one key position (e.g., all 1st chars, all 2nd chars, etc.)
    const accu = Array(26).fill(0); // Accumulated frequency counts across all key positions after applying their best shifts

    for (let j = 0; j < interval; j++) { // Loop through each position in the potential key (0 to keyLength-1)
        // Reset out for the current key position's characters
        out.fill(0);

        // Count frequencies for characters at indices j, j+interval, j+2*interval, ...
        // These characters were all encrypted using the j-th character of the key.
        for (let i = j; i < l; i += interval) {
            out[msg[i]]++; // msg[i] is the 0-25 index of the character
        }

        // Find the best rotation (shift) for this specific frequency distribution ('out').
        // This shift corresponds to the Vigenère key character used at this position 'j'.
        const rot = bestMatch(out);
        keyArray[j] = rot; // Store the best shift (0-25) found for this key position

        // Apply the determined shift ('rot') to the current frequency counts ('out')
        // and add them to the accumulator ('accu'). This simulates shifting each set
        // of characters back as if they were decrypted by the correct key character.
        for (let i = 0; i < 26; i++) {
            accu[i] += out[(i + rot) % 26];
        }
    }

    // Calculate the overall fit score based on the total accumulated frequencies ('accu').
    // This measures how well the combined frequencies, after applying the determined
    // shifts for each key position, match the standard English frequencies.
    const totalAccu = sum(accu);
    let ret = 0.0;
    for (let i = 0; i < 26; i++) {
        const expectedFreq = freq[i];
        const actualFreq = totalAccu > 0 ? accu[i] / totalAccu : 0;
        const d = actualFreq - expectedFreq;
         // Chi-squared like fit score for the overall distribution
        ret += (d * d) / expectedFreq;
    }

    return ret; // Return the overall fit score for this key length hypothesis
}

// Decrypts the text using the Vigenère cipher with the given key.
// Skips non-A-Z characters in the ciphertext and does not advance the
// key index for them, replicating the Go code's behavior.
function decrypt(text, key) {
    let result = '';
    let keyIndex = 0;

    for (let i = 0; i < text.length; i++) {
        const cCode = text.charCodeAt(i);

        if (cCode >= A_CODE && cCode <= Z_CODE) {
            const textCharIndex = cCode - A_CODE; // 0-25 index of ciphertext char
            // Use the key character cyclically
            const keyCharIndex = key.charCodeAt(keyIndex % key.length) - A_CODE; // 0-25 index of key char

            // Vigenere decryption formula: (ciphertext_index - key_index + 26) % 26
            // Adding 26 ensures the result is non-negative before modulo.
            const decryptedCharIndex = (textCharIndex - keyCharIndex + 26) % 26;

            result += String.fromCharCode(decryptedCharIndex + A_CODE);
            keyIndex++; // Advance key index ONLY for processed A-Z characters
        } else {
            // Skip non-A-Z characters entirely, just like the Go code's 'continue'.
            // They are neither decrypted nor cause the key index to advance.
        }
    }
    return result;
}

// Main execution logic
function main() {
    // Remove spaces from the encoded text
    const cleanedEncoded = encoded.replace(/ /g, '');

    // Convert cleaned text to an array of 0-25 integer indices ('A' -> 0, 'B' -> 1, ...)
    const txt = [];
    for (let i = 0; i < cleanedEncoded.length; i++) {
        txt.push(cleanedEncoded.charCodeAt(i) - A_CODE);
    }

    let bestFit = Infinity; // Initialize with a very large value to find the minimum fit score
    let bestKey = "";

    console.log("  Fit     Length   Key");

    // Iterate through potential key lengths from 1 to 26
    for (let j = 1; j <= 26; j++) {
        const keyArray = Array(j); // Array to hold the calculated shifts (0-25) for this length
        const fit = freqEveryNth(txt, keyArray);

        // Convert the array of shifts (0-25) into a key string (A-Z)
        const currentKey = keyArray.map(shift => String.fromCharCode(shift + A_CODE)).join('');

        // Format output line for the current key length
        // toFixed(6) for 6 decimal places, padStart(2, ' ') for 2 characters, space-padded
        let outputLine = `${fit.toFixed(6)}    ${j.toString().padStart(2, ' ')}     ${currentKey}`;

        // Check if this key length gives a better fit than the best found so far
        if (fit < bestFit) {
            bestFit = fit;
            bestKey = currentKey;
            outputLine += " <--- best so far"; // Indicate the best fit found up to this point
        }
        console.log(outputLine);
    }

    console.log("\nBest key :", bestKey);

    // Decrypt the original cleaned text using the best key found
    const decryptedText = decrypt(cleanedEncoded, bestKey);
    console.log("\nDecrypted text:\n" + decryptedText);
}

// Execute the main function
main();
