import os

fn main(){
    words := os.read_lines('unixdict.txt')?

    mut m := map[string][]string{}
    mut ma := 0
    for word in words {
        mut letters := word.split('')
        letters.sort()
        sorted_word := letters.join('')
        if sorted_word in m {
            m[sorted_word] << word
        } else {
            m[sorted_word] = [word]
        }
        if m[sorted_word].len > ma {
            ma = m[sorted_word].len
        }
    }
    for _, a in m {
        if a.len == ma {
            println(a)
        }
    }
}
