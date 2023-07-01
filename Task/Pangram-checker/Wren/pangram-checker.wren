import "/str" for Str

var isPangram = Fn.new { |s|
    s = Str.lower(s)
    var used = List.filled(26, false)
    for (cp in s.codePoints) {
        if (cp >= 97 && cp <= 122) used[cp-97] = true
    }
    for (u in used) if (!u) return false
    return true
}

var candidates = [
    "The quick brown fox jumps over the lazy dog.",
    "New job: fix Mr. Gluck's hazy TV, PDQ!",
    "Peter Piper picked a peck of pickled peppers.",
    "Sphinx of black quartz, judge my vow.",
    "Foxy diva Jennifer Lopez wasn’t baking my quiche.",
    "Grumpy wizards make a toxic stew for the jovial queen."
]

System.print("Are the following pangrams?")
for (candidate in candidates) {
    System.print("  %(candidate) -> %(isPangram.call(candidate))")
}
