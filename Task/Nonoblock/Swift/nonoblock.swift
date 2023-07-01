import Foundation

func nonoblock(cells: Int, blocks: [Int]) {
    print("\(cells) cells and blocks \(blocks):")
    let totalBlockSize = blocks.reduce(0, +)
    if cells < totalBlockSize + blocks.count - 1 {
        print("no solution")
        return
    }

    func solve(cells: Int, index: Int, totalBlockSize: Int, offset: Int) {
        if index == blocks.count {
            count += 1
            print("\(String(format: "%2d", count))  \(String(output))")
            return
        }
        let blockSize = blocks[index]
        let maxPos = cells - (totalBlockSize + blocks.count - index - 1)
        let t = totalBlockSize - blockSize
        var c = cells - (blockSize + 1)
        for pos in 0...maxPos {
            fill(value: ".", offset: offset, count: maxPos + blockSize)
            fill(value: "#", offset: offset + pos, count: blockSize)
            solve(cells: c, index: index + 1, totalBlockSize: t,
                  offset: offset + blockSize + pos + 1)
            c -= 1
        }
    }

    func fill(value: Character, offset: Int, count: Int) {
        output.replaceSubrange(offset..<offset+count,
                               with: repeatElement(value, count: count))
    }

    var output: [Character] = Array(repeating: ".", count: cells)
    var count = 0
    solve(cells: cells, index: 0, totalBlockSize: totalBlockSize, offset: 0)
}

nonoblock(cells: 5, blocks: [2, 1])
print()

nonoblock(cells: 5, blocks: [])
print()

nonoblock(cells: 10, blocks: [8])
print()

nonoblock(cells: 15, blocks: [2, 3, 2, 3])
print()

nonoblock(cells: 5, blocks: [2, 3])
