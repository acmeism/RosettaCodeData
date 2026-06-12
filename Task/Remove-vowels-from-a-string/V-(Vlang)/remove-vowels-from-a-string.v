fn main() {
    mut str := 'The quick brown fox jumps over the lazy dog'
    for val in 'aeiou'.split('') {str = str.replace(val,'')}
    println(str)
}
