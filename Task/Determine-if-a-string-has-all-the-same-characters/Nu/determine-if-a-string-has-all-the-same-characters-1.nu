let strings = ["", "   ", "2", "333", ".55", "tttTTT", "4444   444k", "pépé"]

$strings | each { |str|
    let pos = if $str == "" {
        null
    } else {
        let first_char = ($str | str substring 0..0)
        let chars = ($str | split chars)
        let found = ($chars | enumerate | find { |it| $it.item != $first_char } | get -i 0 | get -i index)
        $found
    }
    let char_info = if $pos != null {
        let char = ($str | str substring $pos..$pos)
        let codepoint = ($char | into int | fmt | get hex)
        $"first different char '($char)' (0x($codepoint)) at position ($pos)."
    } else {
        "all the same."
    }
    $"($str | to nuon) size ($str | str length): ($char_info)"
} | str join "\n" | print
