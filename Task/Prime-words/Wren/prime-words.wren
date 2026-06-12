import "io" for File
import "./math" for Int
import "./iterate" for Stepped

// cache prime characters with codepoints between 33 and 255 say
var primeChars = []
for (i in Stepped.new(33..255, 2)) {
    if (Int.isPrime(i)) primeChars.add(String.fromCodePoint(i))
}
var wordList = "unixdict.txt" // local copy
var words = File.read(wordList).trimEnd().split("\n")
System.print("Prime words in %(wordList) are:")
for (word in words) {
    if (word.all { |c| primeChars.contains(c) }) System.print(word)
}
