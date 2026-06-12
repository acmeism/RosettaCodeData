import Foundation

class PerimeterDetection {
    // Direction constants
    static let E = 0
    static let N = 1
    static let W = 2
    static let S = 3

    // X generates coordinate pairs for a grid of given dimensions
    static func X(_ a: Int, _ b: Int) -> [[Int]] {
        var c: [[Int]] = []
        for aa in 0...a {
            for bb in 0...b {
                c.append([aa, bb])
            }
        }
        return c
    }

    // any checks if any element in the array equals val
    static func any(_ arr: [Int], _ val: Int) -> Bool {
        return arr.contains(val)
    }

    // Result struct to return multiple values from identifyPerimeter
    struct PerimeterResult {
        let x: Int
        let y: Int
        let path: String

        init(x: Int, y: Int, path: String) {
            self.x = x
            self.y = y
            self.path = path
        }
    }

    // identifyPerimeter identifies the perimeter of a shape in a 2D matrix
    static func identifyPerimeter(_ data: [[Int]]) -> PerimeterResult? {
        for coords in X(data[0].count - 1, data.count - 1) {
            let x = coords[0]
            let y = coords[1]

            if y < data.count && x < data[0].count && data[y][x] != 0 {
                var path = ""
                var cx = x, cy = y
                var d = 0, p = 0

                repeat {
                    var mask = 0

                    let vals = [[0, 0, 1], [1, 0, 2], [0, 1, 4], [1, 1, 8]]
                    for val in vals {
                        let dx = val[0], dy = val[1], b = val[2]
                        let mx = cx + dx, my = cy + dy

                        if mx > 0 && my > 0 && my - 1 < data.count &&
                           mx - 1 < data[0].count && data[my - 1][mx - 1] != 0 {
                            mask += b
                        }
                    }

                    if any([1, 5, 13], mask) {
                        d = N
                    }
                    if any([2, 3, 7], mask) {
                        d = E
                    }
                    if any([4, 12, 14], mask) {
                        d = W
                    }
                    if any([8, 10, 11], mask) {
                        d = S
                    }
                    if mask == 6 {
                        if p == N {
                            d = W
                        } else {
                            d = E
                        }
                    }
                    if mask == 9 {
                        if p == E {
                            d = N
                        } else {
                            d = S
                        }
                    }

                    let dirChars: [Character] = ["E", "N", "W", "S"]
                    path.append(dirChars[d])
                    p = d

                    let dxVals = [1, 0, -1, 0]
                    let dyVals = [0, -1, 0, 1]
                    cx += dxVals[d]
                    cy += dyVals[d]

                } while !(cx == x && cy == y)

                return PerimeterResult(x: x, y: -y, path: path)
            }
        }

        print("That did not work out...")
        return nil
    }
}

// Example usage
let M = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 1, 1, 0],
    [0, 0, 0, 1, 0],
    [0, 0, 0, 0, 0]
]

if let result = PerimeterDetection.identifyPerimeter(M) {
    print("X: \(result.x), Y: \(result.y), Path: \(result.path)")
} else {
    print("Failed to detect perimeter")
}
