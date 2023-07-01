let encodedString = encode(input).reduce("") { $0 + "\($1.0)\($1.1)" }
print(encodedString)
let outputString = decode(encodedString)
print(outputString == input)
