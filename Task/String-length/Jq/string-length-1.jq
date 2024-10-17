$ cat String_length.jq
def describe:
   "\(.) has \(length) codepoints and \(utf8bytelength) bytes";

("J̲o̲s̲é̲", "𝔘𝔫𝔦𝔠𝔬𝔡𝔢") | describe
