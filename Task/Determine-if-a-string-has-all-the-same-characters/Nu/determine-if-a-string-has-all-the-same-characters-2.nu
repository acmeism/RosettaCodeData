let strings = ["", "   ", "2", "333", ".55", "tttTTT", "4444   444k", "pépé"]

$strings |
 enumerate |
 iter filter-map { |row|
    let str = $row.item
    let first_diff_pos = if $str == "" {
        null
    } else {
        $str |
         split chars |
         enumerate |
         find { |it| $it.item != ($str | str substring 0..0) } |
         get -i 0.index
    }
    let char_info = if $first_diff_pos == null {
        "all the same."
    } else {
        let pos = $first_diff_pos
        let char = ($str | str substring $pos..$pos)
        let codepoint = ($char | into int | fmt | get hex)
        $"first different char '($char)' (0x($codepoint)) at position ($pos)."
    }
    { out: $"($str | to nuon) size ($str | str length): ($char_info)" }
} |
 get out |
 str join "\n"
