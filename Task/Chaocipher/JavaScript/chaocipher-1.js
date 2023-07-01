const L_ALPHABET = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
const R_ALPHABET = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

const ENCRYPT = 0;
const DECRYPT = 1;

function setCharAt(str, index, chr) {
    if (index > str.length - 1) return str;
    return str.substr(0, index) + chr + str.substr(index + 1);
}

function chao(text, mode, show_steps) {
    var left = L_ALPHABET;
    var right = R_ALPHABET;
    var out = text;
    var temp = "01234567890123456789012345";
    var i = 0;
    var index, j, store;

    if (show_steps) {
        console.log("The left and right alphabets after each permutation during encryption are :");
    }
    while (i < text.length) {
        if (show_steps) {
            console.log(left + "  " + right);
        }
        if (mode == ENCRYPT) {
            index = right.indexOf(text[i]);
            out = setCharAt(out, i, left[index]);
        } else {
            index = left.indexOf(text[i]);
            out = setCharAt(out, i, right[index]);
        }
        if (i == text.length - 1) {
            break;
        }

        //permute left
        j = index;
        while (j < 26) {
            temp = setCharAt(temp, j - index, left[j])
            j += 1;
        }
        j = 0;
        while (j < index) {
            temp = setCharAt(temp, 26 - index + j, left[j]);
            j += 1;
        }
        store = temp[1];
        j = 2;
        while (j < 14) {
            temp = setCharAt(temp, j - 1, temp[j]);
            j += 1;
        }
        temp = setCharAt(temp, 13, store);
        left = temp;

        //permute right
        j = index;
        while (j < 26) {
            temp = setCharAt(temp, j - index, right[j]);
            j += 1;
        }
        j = 0;
        while (j < index) {
            temp = setCharAt(temp, 26 - index + j, right[j]);
            j += 1;
        }
        store = temp[0];
        j = 1;
        while (j < 26) {
            temp = setCharAt(temp, j - 1, temp[j]);
            j += 1;
        }
        temp = setCharAt(temp, 25, store);
        store = temp[2];
        j = 3;
        while (j < 14) {
            temp = setCharAt(temp, j - 1, temp[j]);
            j += 1;
        }
        temp = setCharAt(temp, 13, store);
        right = temp;

        i += 1;
    }

    return out;
}

function main() {
    var out = document.getElementById("content");
    const plain_text = "WELLDONEISBETTERTHANWELLSAID";

    out.innerHTML = "<p>The original plaintext is : " + plain_text + "</p>";
    var cipher_text = chao(plain_text, ENCRYPT, true);
    out.innerHTML += "<p>The ciphertext is : " + cipher_text + "</p>";
    var decipher_text = chao(cipher_text, DECRYPT, false);
    out.innerHTML += "<p>The recovered plaintext is : " + decipher_text + "</p>";
}
