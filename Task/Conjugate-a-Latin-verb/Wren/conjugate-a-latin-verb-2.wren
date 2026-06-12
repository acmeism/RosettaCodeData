import "./fmt" for Fmt

var endings = [
    [ "o", "as", "at", "amus", "atis",  "ant"],
    ["eo", "es", "et", "emus", "etis",  "ent"],
    [ "o", "is", "it", "imus", "itis",  "unt"],
    ["io", "is", "it", "imus", "itis", "iunt"]
]

var infinEndings = ["are", "ēre", "ere", "ire"]

var pronouns = ["I", "you (singular)", "he, she or it", "we", "you (plural)", "they"]

var englishEndings = [ "", "", "s", "", "", "" ]

var conjugate = Fn.new { |infinitive, english|
    var letters = infinitive.toList
    if (letters.count < 4) Fiber.abort("Infinitive is too short for a regular verb.")
    var infinEnding = letters[-3..-1].join()
    var conj = infinEndings.indexOf(infinEnding)
    if (conj == -1) Fiber.abort("Infinitive ending -%(infinEnding) not recognized.")
    var stem = letters[0..-4].join()
    System.print("Present indicative tense, active voice, of '%(infinitive)' to '%(english)':")
    var i = 0
    for (ending in endings[conj]) {
        Fmt.print("    $s$-4s  $s $s$s", stem, ending, pronouns[i], english, englishEndings[i])
        i = i + 1
    }
    System.print()
}

var pairs = [["amare", "love"], ["vidēre", "see"], ["ducere", "lead"], ["audire", "hear"]]
for (pair in pairs) conjugate.call(pair[0], pair[1])
