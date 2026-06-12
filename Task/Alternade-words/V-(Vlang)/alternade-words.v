import os

fn main() {
    bwords := os.read_lines('unixdict.txt')?//bytes.Fields(b)
    mut dict := map[string]bool{}
    mut words := bwords.clone()
    for bword in bwords {
        dict[bword] = true
    }
    println("'unixdict.txt' contains the following alternades of length 6 or more:\n")
    mut count := 0
    for word in words {
        if word.len < 6 {
            continue
        }
        mut w1 := ""
        mut w2 := ""
        for i, c in word {
            if i%2 == 0 {
                w1 += c.ascii_str()
            } else {
                w2 += c.ascii_str()
            }
        }
        ok1 := w1 in dict
        ok2 := w2 in dict
        if ok1 && ok2 {
            count++
            println("${count:2}: ${word:-8} -> ${w1:-4} ${w2:-4}")
        }
    }
}
