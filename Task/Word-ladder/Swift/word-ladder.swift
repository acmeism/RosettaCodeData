import Foundation

func oneAway(string1: [Character], string2: [Character]) -> Bool {
    if string1.count != string2.count {
        return false
    }
    var result = false
    var i = 0
    while i < string1.count {
        if string1[i] != string2[i] {
            if result {
                return false
            }
            result = true
        }
        i += 1
    }
    return result
}

func wordLadder(words: [[Character]], from: String, to: String) {
    let fromCh = Array(from)
    let toCh = Array(to)
    var poss = words.filter{$0.count == fromCh.count}
    var queue: [[[Character]]] = [[fromCh]]
    while !queue.isEmpty {
        var curr = queue[0]
        let last = curr[curr.count - 1]
        queue.removeFirst()
        let next = poss.filter{oneAway(string1: $0, string2: last)}
        if next.contains(toCh) {
            curr.append(toCh)
            print(curr.map{String($0)}.joined(separator: " -> "))
            return
        }
        poss.removeAll(where: {next.contains($0)})
        for str in next {
            var temp = curr
            temp.append(str)
            queue.append(temp)
        }
    }
    print("\(from) into \(to) cannot be done.")
}

do {
    let words = try String(contentsOfFile: "unixdict.txt", encoding: String.Encoding.ascii)
        .components(separatedBy: "\n")
        .filter{!$0.isEmpty}
        .map{Array($0)}
    wordLadder(words: words, from: "man", to: "boy")
    wordLadder(words: words, from: "girl", to: "lady")
    wordLadder(words: words, from: "john", to: "jane")
    wordLadder(words: words, from: "child", to: "adult")
    wordLadder(words: words, from: "cat", to: "dog")
    wordLadder(words: words, from: "lead", to: "gold")
    wordLadder(words: words, from: "white", to: "black")
    wordLadder(words: words, from: "bubble", to: "tickle")
} catch {
    print(error.localizedDescription)
}
