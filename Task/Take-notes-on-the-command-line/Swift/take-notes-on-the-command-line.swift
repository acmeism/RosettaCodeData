import Foundation

let args = Process.arguments
let manager = NSFileManager()
let currentPath = manager.currentDirectoryPath
var err:NSError?

// Create file if it doesn't exist
if !manager.fileExistsAtPath(currentPath + "/notes.txt") {
    println("notes.txt doesn't exist")
    manager.createFileAtPath(currentPath + "/notes.txt", contents: nil, attributes: nil)
}

// handler is what is used to write to the file
let handler = NSFileHandle(forUpdatingAtPath: currentPath + "/notes.txt")

// Print the file if there are no args
if args.count == 1 {
    let str = NSString(contentsOfFile: currentPath + "/notes.txt", encoding: NSUTF8StringEncoding, error: &err)
    println(str!)
    exit(0)
}

let time = NSDate()
let format = NSDateFormatter()
let timeData = (format.stringFromDate(time) + "\n").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
format.dateFormat = "yyyy.MM.dd 'at' HH:mm:ss zzz"

// We're writing to the end of the file
handler?.seekToEndOfFile()
handler?.writeData(timeData!)

var str = "\t"
for i in 1..<args.count {
    str += args[i] + " "
}

str += "\n"

let strData = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
handler?.writeData(strData!)
