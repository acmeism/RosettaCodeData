String[] meaning = ["what,", "is,", "the;", "meaning,", "of:", "life."];
String[] kansas = ["we,", "are,", "not,", "in,", "kansas;", "any,", "more."];

shared void run() {
    print("".join(reverseWords(meaning)));
    print("".join(reverseWords(kansas)));
}

String[] reverseWords(String[] words)
    => recursiveReverseWords(words, []);

String[] recursiveReverseWords(String[] remOrig, String[] revWords)
    => if (nonempty remOrig)
        then recursiveReverseWords(remOrig.rest,
                                   revWords.withTrailing(reverseWordRecursive(remOrig.first.sequence(),
                                                                              [],
                                                                              revWords.size.even)))
        else revWords;

String reverseWordRecursive(Character[] remOldChars, Character[] revChars, Boolean isEven)
    => if (nonempty remOldChars)
        then let (char = remOldChars.first) reverseWordRecursive(remOldChars.rest,
                                                                 conditionalAddChar(char, revChars, isEven),
                                                                 isEven)
        else String(revChars);

Character[] conditionalAddChar(Character char, Character[] chars, Boolean isEven)
    => if (isEven || isPunctuation(char))
        then chars.withTrailing(char)
        else chars.withLeading(char);

Boolean isPunctuation(Character char)
    => ",.:;".contains(char);
