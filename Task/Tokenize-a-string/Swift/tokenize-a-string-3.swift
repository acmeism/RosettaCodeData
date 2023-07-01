let text = "Hello,How,Are,You,Today"
let tokens = split(text, { $0 == "," }) // for single-character separator
println(tokens)
let result = ".".join(tokens)
println(result)
