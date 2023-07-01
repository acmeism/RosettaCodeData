let inputs = [[], ["ABC"], ["ABC", "DEF"], ["ABC", "DEF", "G", "H"]]

func quibbling(var words:[String]) {
    if words.count == 0 {
        println("{}")
    } else if words.count == 1 {
        println("{\(words[0])}")
    } else if words.count == 2 {
        println("{\(words[0]) and \(words[1])}")
    } else {
        var output = "{"
        while words.count != 2 {
            output += words.removeAtIndex(0) + ", "
        }
        output += "\(words.removeAtIndex(0)) and \(words.removeAtIndex(0))}"

        println(output)
    }
}

for word in inputs {
    quibbling(word)
}
