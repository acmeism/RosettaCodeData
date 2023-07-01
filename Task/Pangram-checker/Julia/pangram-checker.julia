function makepangramchecker(alphabet)
    alphabet = Set(uppercase.(alphabet))
    function ispangram(s)
        lengthcheck = length(s) ≥ length(alphabet)
        return lengthcheck && all(c in uppercase(s) for c in alphabet)
    end
    return ispangram
end

const tests = ["Pack my box with five dozen liquor jugs.",
                "The quick brown fox jumps over a lazy dog.",
                "The quick brown fox jumps\u2323over the lazy dog.",
                "The five boxing wizards jump quickly.",
                "This sentence contains A-Z but not the whole alphabet."]

is_english_pangram = makepangramchecker('a':'z')

for s in tests
    println("The sentence \"", s, "\" is ", is_english_pangram(s) ? "" : "not ", "a pangram.")
end
