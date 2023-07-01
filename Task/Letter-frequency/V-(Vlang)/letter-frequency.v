import os
struct LetterFreq {
    rune int
    freq int
}

fn main(){
    file := os.read_file('unixdict.txt')?
    mut freq := map[rune]int{}
    for c in file {
        freq[c]++
    }
    mut lf := []LetterFreq{}
    for k,v in freq {
        lf << LetterFreq{u8(k),v}
    }
    lf.sort_with_compare(fn(a &LetterFreq, b &LetterFreq)int{
        if a.freq > b.freq {
            return -1
        }
        if a.freq < b.freq {
            return 1
        }
        return 0
    })
    for f in lf {
        println('${u8(f.rune).ascii_str()} ${f.rune} $f.freq')
    }
}
