import os

fn main() {
    mut count := 1
    mut text :=''
    unixdict := os.read_file('./unixdict.txt') or {println('Error: file not found') exit(1)}
    for word in unixdict.split_into_lines() {
        if word.contains('a')
        && word.index_any('a') < word.index_any('b')
        && word.index_any('b') < word.index_any('c') {
            text += count++.str() + ': $word \n'
        }
    }
    println(text)
}
