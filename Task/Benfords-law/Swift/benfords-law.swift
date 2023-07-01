import Foundation

/* Reads from a file and returns the content as a String */
func readFromFile(fileName file:String) -> String{

    var ret:String = ""

    let path = Foundation.URL(string: "file://"+file)

    do {
        ret = try String(contentsOf: path!, encoding: String.Encoding.utf8)
    }
    catch {
        print("Could not read from file!")
        exit(-1)
    }

    return ret
}

/* Calculates the probability following Benford's law */
func benford(digit z:Int) -> Double {

    if z<=0 || z>9 {
        perror("Argument must be between 1 and 9.")
        return 0
    }

    return log10(Double(1)+Double(1)/Double(z))
}

// get CLI input
if CommandLine.arguments.count < 2 {
    print("Usage: Benford [FILE]")
    exit(-1)
}

let pathToFile = CommandLine.arguments[1]

// Read from given file and parse into lines
let content = readFromFile(fileName: pathToFile)
let lines = content.components(separatedBy: "\n")

var digitCount:UInt64 = 0
var countDigit:[UInt64] = [0,0,0,0,0,0,0,0,0]

// check digits line by line
for line in lines {
    if line == "" {
        continue
    }
    let charLine = Array(line.characters)
        switch(charLine[0]){
            case "1":
                countDigit[0] += 1
                digitCount += 1
                break
            case "2":
                countDigit[1] += 1
                digitCount += 1
                break
            case "3":
                countDigit[2] += 1
                digitCount += 1
                break
            case "4":
                countDigit[3] += 1
                digitCount += 1
                break
            case "5":
                countDigit[4] += 1
                digitCount += 1
                break
            case "6":
                countDigit[5] += 1
                digitCount += 1
                break
            case "7":
                countDigit[6] += 1
                digitCount += 1
                break
            case "8":
                countDigit[7] += 1
                digitCount += 1
                break
            case "9":
                countDigit[8] += 1
                digitCount += 1
                break
            default:
                break
        }

}

// print result
print("Digit\tBenford [%]\tObserved [%]\tDeviation")
print("~~~~~\t~~~~~~~~~~~~\t~~~~~~~~~~~~\t~~~~~~~~~")
for i in 0..<9 {
    let temp:Double = Double(countDigit[i])/Double(digitCount)
    let ben = benford(digit: i+1)
    print(String(format: "%d\t%.2f\t\t%.2f\t\t%.4f", i+1,ben*100,temp*100,ben-temp))
}
