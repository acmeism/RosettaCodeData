import Foundation

struct RedactionOptions: OptionSet {
    let rawValue: Int

    static let wholeWord       = RedactionOptions(rawValue: 1 << 0)
    static let overKill        = RedactionOptions(rawValue: 1 << 1)
    static let caseInsensitive = RedactionOptions(rawValue: 1 << 2)
}

func redact(text: String, target: String, options: RedactionOptions) throws -> String {
    // Set up a regex search pattern for the specified target.
    // Since it has to be able to match grapheme characters which may
    // be combinations of others in the same string, include catches
    // for "Zero Width Joiner" characters.
    var pattern = "(?<!\\u200d)" + NSRegularExpression.escapedPattern(for: target) + "(?!\\u200d)"
    if options.contains(.wholeWord) {
        // Don't match where preceded or followed by either a hyphen
        // or anything which isn't punctuation or white space.
        pattern = "(?<![-[^[:punct:]\\s]])" + pattern + "(?![-[^[:punct:]\\s]])"
    } else if options.contains(.overKill) {
        // Include any preceding or following run of hyphens and/or
        // non-(punctuation or white-space).
        pattern = "[-[^[:punct:]\\s]]*" + pattern + "[-[^[:punct:]\\s]]*+"
    }
    // Default to case-sensitivity.
    if options.contains(.caseInsensitive) {
        pattern = "(?i)" + pattern
    }
    let regex = try NSRegularExpression(pattern: pattern)
    let mutableText = NSMutableString(string: text)
    // Locate all the matches in the text and replace each character
    // or grapheme in the matched ranges with "X".
    for match in regex.matches(in: text, range: NSRange(text.startIndex..., in: text)) {
        mutableText.replaceOccurrences(of: ".(?:\\u200d.)*+", with: "X",
                                       options: .regularExpression, range: match.range)
    }
    return mutableText as String
}

func optionString(options: RedactionOptions) -> String {
    var result = options.contains(.wholeWord) ? "w" : "p"
    result.append("|")
    result.append(options.contains(.caseInsensitive) ? "i" : "s")
    result.append("|")
    result.append(options.contains(.overKill) ? "o" : "n")
    return result
}

func doBasicTest(target: String, options: RedactionOptions) {
    let text = "Tom? Toms bottom tomato is in his stomach while playing the \"Tom-tom\" brand tom-toms. That's so tom."
    do {
        try print("[\(optionString(options: options))]: \(redact(text: text, target: target, options: options))")
    } catch {
        print(error.localizedDescription)
    }
}

func doBasicTests(target: String) {
    print("Redact '\(target)':")
    doBasicTest(target: target, options: .wholeWord)
    doBasicTest(target: target, options: [.wholeWord, .caseInsensitive])
    doBasicTest(target: target, options: [])
    doBasicTest(target: target, options: .caseInsensitive)
    doBasicTest(target: target, options: .overKill)
    doBasicTest(target: target, options: [.overKill, .caseInsensitive])
}

func doExtraTest(target: String) {
    let text = "🧑 👨 🧔 👨‍👩‍👦"
    do {
        try print("Redact '\(target)':\n[w]: \(redact(text: text, target: target, options: .wholeWord))")
    } catch {
        print(error.localizedDescription)
    }
}

doBasicTests(target: "Tom")
print()

doBasicTests(target: "tom")
print()

doExtraTest(target: "👨")
print()
doExtraTest(target: "👨‍👩‍👦")
