let text = "Hello,How,Are,You,Today"
let tokens = text.characters.split(",").map{String($0)} // for single-character separator
print(tokens)
let result = tokens.joinWithSeparator(".")
print(result)
