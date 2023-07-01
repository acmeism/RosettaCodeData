import os
import strconv

fn main() {
    s := strconv.atoi(os.input('Enter string')) ?
    if s == 75000 {
        println('good')
    } else {
        println('bad $s')
    }
}
