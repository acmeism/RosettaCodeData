const codes = {
    `a` : "AAAAA", `b` : "AAAAB", `c` : "AAABA", `d` : "AAABB", `e` : "AABAA",
    `f` : "AABAB", `g` : "AABBA", `h` : "AABBB", `i` : "ABAAA", `j` : "ABAAB",
    `k` : "ABABA", `l` : "ABABB", `m` : "ABBAA", `n` : "ABBAB", `o` : "ABBBA",
    `p` : "ABBBB", `q` : "BAAAA", `r` : "BAAAB", `s` : "BAABA", `t` : "BAABB",
    `u` : "BABAA", `v` : "BABAB", `w` : "BABBA", `x` : "BABBB", `y` : "BBAAA",
    `z` : "BBAAB", ` ` : "BBBAA"
}

fn bacon_encode(plain_text string, message string) string {
    pt := plain_text.to_lower()
    mut sb := []u8{}
    for c in pt.runes() {
        if c >= `a` && c <= `z` {
            sb << codes[c].bytes()
        } else {
            sb << codes[` `].bytes()
        }
    }
    et := sb.bytestr()
    mg := message.to_lower()  // 'A's to be in lower case, 'B's in upper case
    sb = []  // clear the byte slice
    mut count := 0
    for c in mg {
        if c >= u8(`a`) && c <= u8(`z`) {
            if et[count] == `A` {
                sb << c
            } else {
                sb << c - 32  // upper case equivalent
            }
            count++
            if count == et.len { break }
        } else {
            sb << c
        }
    }
    return sb.bytestr()
}

fn bacon_decode(message string) string {
    mut sb := []u8{}
    for c in message {
        if c >= u8(`a`) && c <= u8(`z`) {
            sb << `A`
        } else if c >= u8(`A`) && c <= u8(`Z`) {
            sb << `B`
        }
    }
    et := sb.bytestr()
    sb = []  // clear the byte slice
    for i := 0; i < et.len; i += 5 {
        quintet := et[i .. i + 5]
        for k, v in codes {
            if v == quintet {
                sb << u8(k)
                break
            }
        }
    }
    return sb.bytestr()
}

fn main() {
    plain_text := "the quick brown fox jumps over the lazy dog"
    message := "bacon's cipher is a method of steganography created by francis bacon." +
        "this task is to implement a program for encryption and decryption of " +
        "plaintext using the simple alphabet of the baconian cipher or some " +
        "other kind of representation of this alphabet (make anything signify anything). " +
        "the baconian alphabet may optionally be extended to encode all lower " +
        "case characters individually and/or adding a few punctuation characters " +
        "such as the space."
    cipher_text := bacon_encode(plain_text, message)
    println("Cipher text ->\n\n$cipher_text")
    decoded_text := bacon_decode(cipher_text)
    println("\nHidden text ->\n\n$decoded_text")
}
