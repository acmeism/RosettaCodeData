import Foundation

let valids = [">", "<", "+", "-", ".", ",", "[", "]"] as Set<Character>
var ip = 0
var dp = 0
var data = [UInt8](count: 30_000, repeatedValue: 0)

let input = Process.arguments

if input.count != 2 {
    fatalError("Need one input file")
}

let infile: String!

do {
    infile = try String(contentsOfFile: input[1], encoding: NSUTF8StringEncoding) ?? ""
} catch let err {
    infile = ""
}

var program = ""

// remove invalid chars
for c in infile.characters {
    if valids.contains(c) {
        program += String(c)
    }
}

let numChars = program.characters.count

if numChars == 0 {
    fatalError("Error reading file")
}

func increaseInstructionPointer() {
    ip += 1
}

func executeInstruction(ins: Character) {
    switch ins {
    case ">":
        dp += 1
        increaseInstructionPointer()
    case "<":
        dp -= 1
        increaseInstructionPointer()
    case "+":
        data[dp] = data[dp] &+ 1
        increaseInstructionPointer()
    case "-":
        data[dp] = data[dp] &- 1
        increaseInstructionPointer()
    case ".":
        print(Character(UnicodeScalar(data[dp])), terminator: "")
        increaseInstructionPointer()
    case ",":
        handleIn()
        increaseInstructionPointer()
    case "[":
        handleOpenBracket()
    case "]":
        handleClosedBracket()
    default:
        fatalError("What")
    }
}

func handleIn() {
    let input = NSFileHandle.fileHandleWithStandardInput()
    let bytes = input.availableData.bytes
    let buf = unsafeBitCast(UnsafeBufferPointer(start: bytes, count: 1),
        UnsafeBufferPointer<UInt8>.self)

    data[dp] = buf[0]
}

func handleOpenBracket() {
    if data[dp] == 0 {
        var i = 1

        while i > 0 {
            ip += 1
            let ins = program[program.startIndex.advancedBy(ip)]

            if ins == "[" {
                i += 1
            } else if ins == "]" {
                i -= 1
            }
        }
    } else {
        increaseInstructionPointer()
    }
}

func handleClosedBracket() {
    if data[dp] != 0 {
        var i = 1

        while i > 0 {
            ip -= 1
            let ins = program[program.startIndex.advancedBy(ip)]

            if ins == "[" {
                i -= 1
            } else if ins == "]" {
                i += 1
            }
        }
    } else {
        increaseInstructionPointer()
    }
}

func tick() {
    let ins = program[program.startIndex.advancedBy(ip)]

    if valids.contains(ins) {
        executeInstruction(ins)
    } else {
        increaseInstructionPointer()
    }
}

while ip != numChars {
    tick()
}
