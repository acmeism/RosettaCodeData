import "/module" for Expect, Suite, ConsoleReporter

var isPal = Fn.new { |word| word == ((word.count > 0) ? word[-1..0] : "") }

var words = ["rotor", "rosetta", "step on no pets", "été", "wren", "🦊😀🦊"]
var expected = [true, false, true, true, false, true]

var TestPal = Suite.new("Pal") { |it|
    it.suite("'isPal' function:") { |it|
        for (i in 0...words.count) {
            it.should("return '%(expected[i])' for '%(words[i])' is palindrome") {
                Expect.call(isPal.call(words[i])).toEqual(expected[i])
            }
        }
    }
}

var reporter = ConsoleReporter.new()
TestPal.run(reporter)
reporter.epilogue()
