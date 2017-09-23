let text = "Hello,How,Are,You,Today"
let tokens = text.components(separatedBy: ",") // for single or multi-character separator
print(tokens)
let result = tokens.joined(separator: ".")
print(result)
