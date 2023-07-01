def s1: "longer";
def s2: "shorter😀";

[s1,s2]
| sort_by(length)
| reverse[]
| "\"\(.)\" has length (codepoints) \(length) and utf8 byte length \(utf8bytelength)."
