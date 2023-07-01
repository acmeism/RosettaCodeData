import os
import strings
type PlayfairOption = int

const (
    no_q = 0
    i_equals_j = 1
)

struct Playfair {
mut:
    keyword string
    pfo     PlayfairOption
    table   [5][5]u8
}

fn (mut p Playfair) init() {
    // Build table.
    mut used := [26]bool{} // all elements false
    if p.pfo == no_q {
        used[16] = true // Q used
    } else {
        used[9] = true // J used
    }
    alphabet := p.keyword.to_upper() + "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for i, j, k := 0, 0, 0; k < alphabet.len; k++ {
        c := alphabet[k]
        if c < 'A'[0] || c > 'Z'[0] {
            continue
        }
        d := int(c - 65)
        if !used[d] {
            p.table[i][j] = c
            used[d] = true
            j++
            if j == 5 {
                i++
                if i == 5 {
                    break // table has been filled
                }
                j = 0
            }
        }
    }
}

fn (p Playfair) get_clean_text(pt string) string {
    // Ensure everything is upper case.
    plain_text := pt.to_upper()
    // Get rid of any non-letters and insert X between duplicate letters.
    mut clean_text := strings.new_builder(128)
    // Safe to assume null u8 won't be present in plain_text.
    mut prev_byte := `\000`
    for i in 0..plain_text.len {
        mut next_byte := plain_text[i]
        // It appears that Q should be omitted altogether if NO_Q option is specified;
        // we assume so anyway.
        if next_byte < 'A'[0] || next_byte > 'Z'[0] || (next_byte == 'Q'[0] && p.pfo == no_q) {
            continue
        }
        // If i_equals_j option specified, replace J with I.
        if next_byte == 'J'[0] && p.pfo == i_equals_j {
            next_byte = 'I'[0]
        }
        if next_byte != prev_byte {
            clean_text.write_u8(next_byte)
        } else {
            clean_text.write_u8('X'[0])
            clean_text.write_u8(next_byte)
        }
        prev_byte = next_byte
    }
    l := clean_text.len
    if l%2 == 1 {
        // Dangling letter at end so add another letter to complete digram.
        if clean_text.str()[l-1] != 'X'[0] {
            clean_text.write_u8('X'[0])
        } else {
            clean_text.write_u8('Z'[0])
        }
    }
    return clean_text.str()
}

fn (p Playfair) find_byte(c u8) (int, int) {
    for i in 0..5 {
        for j in 0..5 {
            if p.table[i][j] == c {
                return i, j
            }
        }
    }
    return -1, -1
}

fn (p Playfair) encode(plain_text string) string {
    clean_text := p.get_clean_text(plain_text)
    mut cipher_text := strings.new_builder(128)
    l := clean_text.len
    for i := 0; i < l; i += 2 {
        row1, col1 := p.find_byte(clean_text[i])
        row2, col2 := p.find_byte(clean_text[i+1])
        if row1 == row2{
            cipher_text.write_u8(p.table[row1][(col1+1)%5])
            cipher_text.write_u8(p.table[row2][(col2+1)%5])
        } else if col1 == col2{
            cipher_text.write_u8(p.table[(row1+1)%5][col1])
            cipher_text.write_u8(p.table[(row2+1)%5][col2])
        } else {
            cipher_text.write_u8(p.table[row1][col2])
            cipher_text.write_u8(p.table[row2][col1])
        }
        if i < l-1 {
            cipher_text.write_u8(' '[0])
        }
    }
    return cipher_text.str()
}

fn (p Playfair) decode(cipher_text string) string {
    mut decoded_text := strings.new_builder(128)
    l := cipher_text.len
    // cipher_text will include spaces so we need to skip them.
    for i := 0; i < l; i += 3 {
        row1, col1 := p.find_byte(cipher_text[i])
        row2, col2 := p.find_byte(cipher_text[i+1])
        if row1 == row2 {
            mut temp := 4
            if col1 > 0 {
                temp = col1 - 1
            }
            decoded_text.write_u8(p.table[row1][temp])
            temp = 4
            if col2 > 0 {
                temp = col2 - 1
            }
            decoded_text.write_u8(p.table[row2][temp])
        } else if col1 == col2 {
            mut temp := 4
            if row1 > 0 {
                temp = row1 - 1
            }
            decoded_text.write_u8(p.table[temp][col1])
            temp = 4
            if row2 > 0 {
                temp = row2 - 1
            }
            decoded_text.write_u8(p.table[temp][col2])
        } else {
            decoded_text.write_u8(p.table[row1][col2])
            decoded_text.write_u8(p.table[row2][col1])
        }
        if i < l-1 {
            decoded_text.write_u8(' '[0])
        }
    }
    return decoded_text.str()
}

fn (p Playfair) print_table() {
    println("The table to be used is :\n")
    for i in 0..5 {
        for j in 0..5 {
            print("${p.table[i][j].ascii_str()} ")
        }
        println('')
    }
}

fn main() {
    keyword := os.input("Enter Playfair keyword : ")
    mut ignore_q := ''
    for ignore_q != "y" && ignore_q != "n" {
        ignore_q = os.input("Ignore Q when building table  y/n : ").to_lower()
    }
    mut pfo := no_q
    if ignore_q == "n" {
        pfo = i_equals_j
    }
    mut table := [5][5]u8{}
    mut pf := Playfair{keyword, pfo, table}
    pf.init()
    pf.print_table()
    plain_text := os.input("\nEnter plain text : ")
    encoded_text := pf.encode(plain_text)
    println("\nEncoded text is : $encoded_text")
    decoded_text := pf.decode(encoded_text)
    println("Deccoded text is : $decoded_text")
}
