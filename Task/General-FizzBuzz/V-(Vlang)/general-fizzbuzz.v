import os

fn main() {
    max := os.input('Max: ').int()
    f1 := os.input('Starting factor (#) and word: ').fields()
    f2 := os.input('Next factor (#) and word: ').fields()
    f3 := os.input('Next factor (#) and word: ').fields()

    //using the provided data
    words := {
        f1[0].int(): f1[1],
        f2[0].int(): f2[1],
        f3[0].int(): f3[1],
    }
    keys := words.keys()
    mut divisible := false
    for i := 1; i <= max; i++ {
        for n in keys {
            if i % n == 0 {
                print(words[n])
                divisible = true
            }
        }
        if !divisible {
            print(i)
        }
        println('')
        divisible = false
    }
}
