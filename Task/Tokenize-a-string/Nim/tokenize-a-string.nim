import strutils

let text = "Hello,How,Are,You,Today"
let tokens = text.split(',')
echo tokens.join(" ")
