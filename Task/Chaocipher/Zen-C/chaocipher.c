enum CMode {
    ENCRYPT,
    DECRYPT
}

def L_ALPHABET = "HXUCZVAMDSLKPEFJRIGTWOBNYQ";
def R_ALPHABET = "PTLNBQDEOYSFAVZKGJRIHWXUMC";

fn chao(input: const char*, output: char*, mode: CMode, show_steps: bool) {
    let len = strlen(input);
    let left:  char[27];
    let right: char[27];
    let temp:  char[27];
    strcpy(left, L_ALPHABET);
    strcpy(right, R_ALPHABET);
    temp[26] = '\0';

    for i in 0..len {
        if show_steps { println "{left}  {right}"; }
        let index: int;
        if mode == CMode::ENCRYPT {
            index = strchr(right, input[i]) - right;
            output[i] = left[index];
        } else {
            index = strchr(left, input[i]) - left;
            output[i] = right[index];
        }
        if i == len - 1 { break; }
        let store: char;

        /* permute left */

        for let j = index; j < 26; ++j { temp[j - index] = left[j]; }
        for let j = 0; j < index; ++j  { temp[26 - index + j] = left[j]; }
        store = temp[1];
        for let j = 2; j < 14; ++j { temp[j - 1] = temp[j]; }
        temp[13] = store;
        strcpy(left, temp);

        /* permute right */

        for let j = index; j < 26; ++j { temp[j - index] = right[j]; }
        for let j = 0; j < index; ++j  { temp[26 - index + j] = right[j]; }
        store = temp[0];
        for let j = 1; j < 26; ++j { temp[j - 1] = temp[j]; }
        temp[25] = store;
        store = temp[2];
        for let j = 3; j < 14; ++j { temp[j - 1] = temp[j]; }
        temp[13] = store;
        strcpy(right, temp);
    }
}

fn main() {
    let plain_text = "WELLDONEISBETTERTHANWELLSAID";
    autofree let cipher_text = (char*)malloc(strlen(plain_text) + 1);
    autofree let plain_text2 = (char*)malloc(strlen(plain_text) + 1);
    println "The original plaintext is : {plain_text}";
    println "\nThe left and right alphabets after each permutation during encryption are :\n";
    chao(plain_text, cipher_text, CMode::ENCRYPT, true);
    println "\nThe ciphertext is : {cipher_text}";
    chao(cipher_text, plain_text2, CMode::DECRYPT, false);
    println "\nThe recovered plaintext is : {plain_text2}";
}
