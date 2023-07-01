fn main() {
    str := 'abcd'
    println(str.starts_with('ab')) // True
    println(str.ends_with('zn')) // False
    println(str.contains('bb')) // False
    println(str.contains('ab')) // True
    println(str.index('bc') or {-1}) // 1 // Vlang arrays are 0 based, so first char position is 0 and no result assigned -1
}
