import Foundation

func main() {
    let maximumArea = 1_000
    let halfMaximumArea = maximumArea / 2

    var ohalloranNumbers = Array(repeating: true, count: halfMaximumArea)

    for length in 1..<maximumArea {
        for width in 1..<halfMaximumArea {
            for height in 1..<halfMaximumArea {
                let halfArea = length * width + length * height + width * height
                if halfArea < halfMaximumArea {
                    ohalloranNumbers[halfArea] = false
                }
            }
        }
    }

    print("Values larger than 6 and less than 1,000 which cannot be the surface area of a cuboid:")
    for i in 3..<halfMaximumArea where ohalloranNumbers[i] {
        print(i * 2, terminator: " ")
    }
    print()
}

// Running the main function
main()
