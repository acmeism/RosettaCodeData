import Foundation
import GameplayKit  // for use of inbuilt Fisher-Yates-Shuffle

/* Prints the usage of this code */
func printHelp() -> Void {
    print("Usage: PasswordGenerator [-l:length] [-c:count] [-s:seed] [-x:exclude] [-h:help]")
    print("\t-l: length of the passwords (at leas 4 characters)")
    print("\t-c: number of passwords to generate")
    print("\t-s: seed of the random number generator")
    print("\t-x: exclude of visually similar characters \"Il1O05S2Z\"")
    print("\t-h: print this help")
    exit(0)
}

/* Set characters for generating passwords */
let _lower:String = "abcdefghijklmnopqrstuvwxyz"
let _lowerWithoutSimilar:String = "abcdefghijkmnopqrstuvwxyz"
let _upper:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let _upperWithoutSimilar = "ABCDEFGHJKLMNPQRTUVWXY"
let _number:String = "0123456789"
let _numerWithoutSimilar:String = "1346789"
let _other:String = "!\"#$%&'()*+,-./:;<=>?@[]^_{|}~"

/* Generate character arrays out of strings */
let upper = Array(_upper.characters)
let upperWithoutSimilar = Array(_upperWithoutSimilar.characters)
let lower = Array(_lower.characters)
let lowerWithoutSimilar = Array(_lowerWithoutSimilar.characters)
let other = Array(_other.characters)
let number = Array(_number.characters)
let numberWithoutSimilar = Array(_numerWithoutSimilar.characters)

var length:Int=0, count:Int=0, seed:Int=0, xclude:Bool=false

/* Parse CLI arguments */
for i in 1..<CommandLine.arguments.count{
    var arg = CommandLine.arguments[i]
    var argument = arg.components(separatedBy: ":")
    switch(argument[0]){
    case "-l":
        length=Int(argument[1])!
        if length < 4 {
            print("A password must contain of at least 4 characters.")
            exit(-1)
        }
        break
    case "-c":
        count=Int(argument[1])!
        break
    case "-s":
        seed=Int(argument[1])!
        break
    case "-x":
        xclude=true
        break
    case "-h":
        printHelp()
    default:
        print("Could not parse CLI arguments. Use -h for help.")
        exit(0)
    }
}

/* Generate password of given length */
func generatePassword(length len:Int, exclude xcl:Bool) -> String{

    var ret:String = "", loopCount:Int = 0

    while(loopCount < len){
        if ret.characters.count < len {
            if xcl {
                ret += String(upperWithoutSimilar[Int(getRand(Int32(upperWithoutSimilar.count-1)))])
            }
            else {
                ret += String(upper[Int(getRand(Int32(upper.count)))])
            }
        }

        if ret.characters.count < len {
            if xcl {
                ret += String(lowerWithoutSimilar[Int(getRand(Int32(lowerWithoutSimilar.count-1)))])
            }
            else {
                ret += String(lower[Int(getRand(Int32(lower.count-1)))])
            }
        }

        if ret.characters.count < len {
            if xcl {
                ret += String(numberWithoutSimilar[Int(getRand(Int32(numberWithoutSimilar.count-1)))])
            }
            else {
                ret += String(number[Int(getRand(Int32(number.count-1)))])
            }
        }

        if ret.characters.count < len {
            ret += String(other[Int(getRand(Int32(other.count-1)))])
        }
        loopCount += 4
    }

    // Shuffle the array with an internal shuffle function
    let shuffled = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: Array(ret.characters))
    ret = ""
    for element in shuffled {
        ret += String(describing: element)
    }
    return ret
}

if xclude {
    print("Generating \(count) passwords with length \(length) excluding visually similar characters...")
}
else {
    print("Generating \(count) passwords with length \(length) not excluding visually similar characters...")
}

initRandom(UInt32(0))    // initialize with C func srand()

// generate the passwords
for i in 1...count {
    print("\(i).\t\(generatePassword(length:length,exclude:xclude))")
}
