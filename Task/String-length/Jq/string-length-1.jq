$ cat String_length.jq
def describe:
   "length of \(.) is \(length)";

("J̲o̲s̲é̲", "𝔘𝔫𝔦𝔠𝔬𝔡𝔢") | describe
