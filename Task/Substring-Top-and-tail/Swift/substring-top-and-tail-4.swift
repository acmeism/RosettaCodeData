extension String {

    /// Ensure positive indexes

    private func positive(index: Int) -> Int {

        if index >= 0 { return index }

        return count(self) + index
    }

    /// Unicode character by zero-based integer (character) `index`
    /// Supports negative character index to count from end. (-1 returns character before last)

    subscript(index: Int) -> Character {

        return self[advance(startIndex, positive(index))]
    }

    /// String slice by character index

    subscript(range: Range<Int>) -> String {

        return self[advance(startIndex, range.startIndex) ..<
                    advance(startIndex, range.endIndex, endIndex)]
    }

    /// Left portion of text to `index`

    func left(index : Int) -> String {

        return self[0 ..< positive(index)]
    }

    /// Right portion of text from `index`

    func right(index : Int) -> String{

        return self[positive(index) ..< count(self)]
    }

    /// From `start` index until `end` index

    func mid(start: Int, _ end: Int) -> String {

        return self[positive(start) ..< positive(end)]
    }

}

let txt = "0123456789"

txt.right(1) // Right part without first character
txt.left(-1) // Left part without last character
txt.mid(1,-1) // Middle part without first and last character
