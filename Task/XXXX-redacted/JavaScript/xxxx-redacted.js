function redact(source, word, partial, insensitive, overkill) {
    let temp = source.split('');
    const different = (s, w) => {
        if (insensitive) {
            return s.toUpperCase() !== w.toUpperCase();
        } else {
            return s !== w;
        }
    };
    const isWordChar = (c) => {
        return c === '-' || /[a-zA-Z]/.test(c);
    };
    for (let i = 0; i < temp.length - word.length + 1; i++) {
        let match = true;
        for (let j = 0; j < word.length; j++) {
            if (different(temp[i + j], word[j])) {
                match = false;
                break;
            }
        }
        if (match) {
            let beg = i;
            let end = i + word.length;
            if (!partial) {
                if (beg > 0 && isWordChar(temp[beg - 1])) {
                    continue;
                }
                if (end < temp.length && isWordChar(temp[end])) {
                    continue;
                }
            }
            if (overkill) {
                while (beg > 0 && isWordChar(temp[beg - 1])) {
                    beg--;
                }
                while (end < temp.length && isWordChar(temp[end])) {
                    end++;
                }
            }
            for (let k = beg; k < end; k++) {
                temp[k] = 'X';
            }
        }
    }
    return temp.join('');
}

function example(source, word) {
    console.log(`Redact ${word}`);
    console.log(`[w|s|n] ${redact(source, word, false, false, false)}`);
    console.log(`[w|i|n] ${redact(source, word, false, true, false)}`);
    console.log(`[p|s|n] ${redact(source, word, true, false, false)}`);
    console.log(`[p|i|n] ${redact(source, word, true, true, false)}`);
    console.log(`[p|s|o] ${redact(source, word, true, false, true)}`);
    console.log(`[p|i|o] ${redact(source, word, true, true, true)}`);
    console.log();
}

const text = "Tom? Toms bottom tomato is in his stomach while playing the \"Tom-tom\" brand tom-toms. That's so tom";
example(text, "Tom");
example(text, "tom");

