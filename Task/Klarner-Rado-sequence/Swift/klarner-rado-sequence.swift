import Foundation

func initKlarnerRadoSequence(limit: Int) -> [Int] {
    var result = Array(repeating: 0, count: limit + 1)
    var i2 = 1
    var i3 = 1
    var m2 = 1
    var m3 = 1

    for i in 1...limit {
        let minimum = min(m2, m3)
        result[i] = minimum
        if m2 == minimum {
            m2 = result[i2] * 2 + 1
            i2 += 1
        }
        if m3 == minimum {
            m3 = result[i3] * 3 + 1
            i3 += 1
        }
    }
    return result
}

let limit = 1000000
let klarnerRado = initKlarnerRadoSequence(limit: limit)

print("The first 100 elements of the Klarner-Rado sequence:")
for i in 1...100 {
    print(String(format: "%3d", klarnerRado[i]), terminator: "")
    if i % 10 == 0 {
        print()
    } else {
        print(" ", terminator: "")
    }
}
print()

var index = 1000
while index <= limit {
    print("The \(index)th element of Klarner-Rado sequence is \(klarnerRado[index])")
    index *= 10
}
