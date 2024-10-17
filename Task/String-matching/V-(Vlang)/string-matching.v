fn main() {
    str := 'abcd'
    println(str.starts_with('ab')) // True
    println(str.ends_with('zn')) // False
    println(str.contains('bb')) // False
    println(str.contains('ab')) // True
    println(str.index('bc') or {-1}) // 1 // V arrays are 0 based; first char position is 0
}
