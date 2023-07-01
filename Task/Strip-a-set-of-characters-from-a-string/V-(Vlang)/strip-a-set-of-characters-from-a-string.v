fn main() {
    println(stripchars("She was a soul stripper. She took my heart!","aei"))
}

fn stripchars(str string, charstrip string) string {
    mut newstr := str
    for element in charstrip {newstr = newstr.replace(element.ascii_str(), '')}
    return newstr
}
