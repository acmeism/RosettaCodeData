print("Enter a string: ", terminator: "")
guard let str = readLine() else {
    fatalError("Nothing read!")
}
print(str)
print("Enter a number: ", terminator: "")
guard let nstr = readLine(), let num = Int(nstr) else {
    fatalError("Not a number!")
}
print(num)
