import UIKit

// testing examples
let beforeTxt = """
1100111
1100111
1100111
1100111
1100110
1100110
1100110
1100110
1100110
1100110
1100110
1100110
1111110
0000000
"""

let smallrc01 = """
00000000000000000000000000000000
01111111110000000111111110000000
01110001111000001111001111000000
01110000111000001110000111000000
01110001111000001110000000000000
01111111110000001110000000000000
01110111100000001110000111000000
01110011110011101111001111011100
01110001111011100111111110011100
00000000000000000000000000000000
"""

let rc01 = """
00000000000000000000000000000000000000000000000000000000000
01111111111111111100000000000000000001111111111111000000000
01111111111111111110000000000000001111111111111111000000000
01111111111111111111000000000000111111111111111111000000000
01111111100000111111100000000001111111111111111111000000000
00011111100000111111100000000011111110000000111111000000000
00011111100000111111100000000111111100000000000000000000000
00011111111111111111000000000111111100000000000000000000000
00011111111111111110000000000111111100000000000000000000000
00011111111111111111000000000111111100000000000000000000000
00011111100000111111100000000111111100000000000000000000000
00011111100000111111100000000111111100000000000000000000000
00011111100000111111100000000011111110000000111111000000000
01111111100000111111100000000001111111111111111111000000000
01111111100000111111101111110000111111111111111111011111100
01111111100000111111101111110000001111111111111111011111100
01111111100000111111101111110000000001111111111111011111100
00000000000000000000000000000000000000000000000000000000000
"""

// Zhang-Suen thinning algorithm in Swift
/// function to thin the image
func zhangSuen(image: inout [[Int]]) -> [[Int]] {
    // array of x, y position where need to changed to be white
    var changing1, changing2: [(Int, Int)]
    repeat {
        // set to empty array
        changing1 = []
        changing2 = []
        // Step 1
        // loop through row of image
        for y in 1..<image.count-1 {
            // loop through column of image
            for x in 1..<image[0].count-1 {
                // get neighbours of P1
                var nb = neighbours(x: x, y: y, image: image)
                // set P2, P4, P6, P8 from neighbours
                let P2 = nb[0], P4 = nb[2], P6 = nb[4], P8 = nb[6]
                // reference: https://www.hackingwithswift.com/example-code/language/how-to-sum-an-array-of-numbers-using-reduce
                // reference: https://www.hackingwithswift.com/articles/90/how-to-check-whether-a-value-is-inside-a-range
                if (image[y][x] == 1 &&                      // Condision 0
                    (2...6).contains(nb.reduce(0, +)) &&     // Condision 1
                    transitions(neighbours: &nb) == 1 &&     // Condision 2
                    P2 * P4 * P6 == 0 &&                     // Condision 3
                    P4 * P6 * P8 == 0                        // Condision 4
                ) {
                    // add to step1 changing1 list
                    changing1.append((x,y))
                }
            }
        }
        // loop through step1 changing1 list and change to white
        for (x, y) in changing1 {
            image[y][x] = 0
        }
        // Step 2
        // loop through row of image
        for y in 1..<image.count-1 {
            // loop through column of image
            for x in 1..<image[0].count-1 {
                // get neighbours of P1
                var nb = neighbours(x: x, y: y, image: image)
                // set P2, P4, P6, P8 from neighbours
                let P2 = nb[0], P4 = nb[2], P6 = nb[4], P8 = nb[6]
                if (image[y][x] == 1 &&                      // Condision 0
                    (2...6).contains(nb.reduce(0, +)) &&     // Condision 1
                    transitions(neighbours: &nb) == 1 &&     // Condision 2
                    P2 * P4 * P8 == 0 &&                     // Condision 3
                    P2 * P6 * P8 == 0                        // Condision 4
                ) {
                    // add to step2 changing2 list
                    changing2.append((x,y))
                }
            }
        }
        // loop through step2 changing2 list and change to white
        for (x, y) in changing2 {
            image[y][x] = 0
        }
        // finish loop when there's no more place to change to white, when changing1, changing2 are empty
    } while !changing1.isEmpty && !changing2.isEmpty
    // return updated image
    return image
}

/// function to convert multiline string of 1/0 into 2D Int array
func intarray(binstring: String) -> [[Int]] {
    // reference: https://stackoverflow.com/questions/28611336/how-to-convert-a-string-numeric-in-a-int-array-in-swift
    // map through each char of input String to convert to Int
    return binstring.split(separator: "\n").map {$0.compactMap{$0.wholeNumberValue}}
}

/// function to convert 2D Int array of 1/0 into multiline String of ‘#’ and ‘.’
func toTxt(intmatrix: [[Int]]) -> String {
    // map through each array of parent array and
    // map through element of child array and convert to '#' when 1 and to '.' when 0
    return intmatrix.map {$0.map { $0 == 1 ? "#" : "."}.joined(separator: "")}.joined(separator: "\n")
}

/// function to get neighbours of P1 = [P2,P3,P4,P5,P6,P7,P8,P9]
func neighbours(x: Int, y: Int, image: [[Int]]) -> [Int] {
    let i = image
    // set x, y positions of P1 neighbours
    let x1 = x+1, y1 = y-1, x_1 = x-1, y_1 = y+1
    // return neighbours of P1
    return [i[y1][x],  i[y1][x1],   i[y][x1],  i[y_1][x1],  // P2,P3,P4,P5
            i[y_1][x], i[y_1][x_1], i[y][x_1], i[y1][x_1]]  // P6,P7,P8,P9
}

/// function to get the number of transitions from white to black, (0 -> 1) in the sequence P2,P3,P4,P5,P6,P7,P8,P9,P2.
func transitions(neighbours: inout [Int]) -> Int {
    // add P2 at the end of neighbours array
    let n = neighbours + [neighbours[0]]
    var result = 0
    // reference: https://www.marcosantadev.com/arrayslice-in-swift/
    // compare between each element of neightbour and next element of the element to check if the transition is 0 -> 1
    for (n1, n2) in zip(n, n.suffix(n.count - 1)) {
        // if the pattern matches, increament result to 1
        if (n1, n2) == (0, 1) { result += 1 }
    }
    // return number of transitions from 0 to 1
    return result
}

// run testing
// array of test examples
let testCases: [String] = [beforeTxt, smallrc01, rc01]
for picture in testCases {
    // convert string to 2D Int array
    var image = intarray(binstring: picture)
    // print the result
    print("\nFrom:\n\(toTxt(intmatrix: image))")
    // run through Zhang-Suen thinning algorithm
    let after = zhangSuen(image: &image)
    // print the result
    print("\nTo thinned:\n\(toTxt(intmatrix: after))")
}
