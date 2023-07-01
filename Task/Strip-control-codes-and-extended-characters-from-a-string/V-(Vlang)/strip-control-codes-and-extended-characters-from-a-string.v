fn main() {
    println(stripped("\ba\x00b\n\rc\fd\xc3"))
}

fn stripped(source string) string {
    mut result := ''
    for value in source	{if value > 31 && value < 128 {result += value.ascii_str()}}
    return result
}
