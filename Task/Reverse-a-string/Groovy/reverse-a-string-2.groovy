def string = "as⃝df̅"

List combiningBlocks = [
    Character.UnicodeBlock.COMBINING_DIACRITICAL_MARKS,
    Character.UnicodeBlock.COMBINING_DIACRITICAL_MARKS_SUPPLEMENT,
    Character.UnicodeBlock.COMBINING_HALF_MARKS,
    Character.UnicodeBlock.COMBINING_MARKS_FOR_SYMBOLS
]
List chars = string as List
chars[1..-1].eachWithIndex { ch, i ->
    if (Character.UnicodeBlock.of((char)ch) in combiningBlocks) {
        chars[i..(i+1)] = chars[(i+1)..i]
    }
}
println chars.reverse().join()
