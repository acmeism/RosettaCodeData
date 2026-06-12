import "io" for File
import "random" for Random
import "./str" for Strs

var markov = Fn.new { |filePath, keySize, outputSize|
    if (keySize < 1) Fiber.abort("Key size can't be less than 1")
    var words = File.read(filePath).trimEnd().split(" ")
    var wordCount = words.count
    if (outputSize < keySize || outputSize > wordCount) Fiber.abort("Output size is out of range")
    var dict = {}
    for (i in 0..(wordCount - keySize)) {
        var prefix = Strs.join(words[i...i + keySize], " ")
        var suffix = (i + keySize < wordCount) ? words[i + keySize] : ""
        if (!dict.containsKey(prefix)) dict[prefix] = []
        dict[prefix].add(suffix)
    }
    var output = []
    var r = Random.new()
    var prefix = r.sample(dict.keys.toList)
    output.addAll(prefix.split(" "))
    for (n in 1..wordCount) {
        var nextWord = r.sample(dict[prefix].toList)
        if (nextWord.isEmpty) break
        output.add(nextWord)
        if (output.count >= outputSize) break
        prefix = Strs.join(output[n...n + keySize], " ")
    }
    return Strs.join(output.take(outputSize).toList, " ")
}

System.print(markov.call("alice_oz.txt", 3, 100))
