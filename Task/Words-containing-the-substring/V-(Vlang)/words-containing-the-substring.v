import os

fn main() {
    mut count := 1
    mut text :=''
    unixdict := os.read_file('./unixdict.txt') or {panic('file not found')}
    for word in unixdict.split_into_lines() {
        if word.contains('the') && word.len > 11 {text += count++.str() + ': $word \n'}
    }
    println(text)
}
