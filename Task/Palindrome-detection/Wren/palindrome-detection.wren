var isPal = Fn.new { |word| word == ((word.count > 0) ? word[-1..0] : "") }

System.print("Are the following palindromes?")
for (word in ["rotor", "rosetta", "step on no pets", "été", "wren", "🦊😀🦊"]) {
    System.print("  %(word) => %(isPal.call(word))")
}
