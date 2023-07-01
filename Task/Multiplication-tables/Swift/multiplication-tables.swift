import Foundation

let size = 12

func printRow(with:Int, upto:Int) {

    print(String(repeating: " ", count: (with-1)*4), terminator: "")

    for i in with...upto {
            print(String(format: "%l4d", i*with), terminator: "")
    }
    print()
}

print("    ", terminator: ""); printRow( with: 1, upto: size)
print( String(repeating: "–", count: (size+1)*4 ))
for i in 1...size {
    print(String(format: "%l4d",i), terminator:"")
    printRow( with: i, upto: size)
 }
