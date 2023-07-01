type Mode = int
const(
    encrypt = Mode(0)
    decrypt = Mode(1)
)

const(
    l_alphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    r_alphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
)

fn chao(text string, mode Mode, show_steps bool) string {
    len := text.len
    if text.bytes().len != len {
        println("Text contains non-ASCII characters")
        return ""
    }
    mut left  := l_alphabet
    mut right := r_alphabet
    mut e_text := []u8{len: len}
    mut temp  := []u8{len: 26}

    for i in 0..len {
        if show_steps {
            println('$left $right')
        }
        mut index := 0
        if mode == encrypt {
            index = right.index_u8(text[i])
            e_text[i] = left[index]
        } else {
            index = left.index_u8(text[i])
            e_text[i] = right[index]
        }
        if i == len - 1 {
            break
        }

        // permute left
        for j in index..26 {
            temp[j - index] = left[j]
        }
        for j in 0..index {
            temp[26 - index + j] = left[j]
        }
        mut store := temp[1]
        for j in 2..14 {
            temp[j - 1] = temp[j]
        }
        temp[13] = store
        left = temp.bytestr()

        // permute right

        for j in index..26 {
            temp[j - index] = right[j]
        }
        for j in 0..index {
            temp[26 - index + j] = right[j]
        }
        store = temp[0]
        for j in 1..26 {
            temp[j - 1] = temp[j]
        }
        temp[25] = store
        store = temp[2]
        for j in 3..14 {
            temp[j - 1] = temp[j]
        }
        temp[13] = store
        right = temp.bytestr()
    }

    return e_text.bytestr()
}

fn main() {
    plain_text := "WELLDONEISBETTERTHANWELLSAID"
    println("The original plaintext is : $plain_text")
    print("\nThe left and right alphabets after each permutation ")
    println("during encryption are :\n")
    cypher_text := chao(plain_text, encrypt, true)
    println("\nThe ciphertext is : $cypher_text")
    plain_text2 := chao(cypher_text, decrypt, false)
    println("\nThe recovered plaintext is : $plain_text2")
}
