import random, sequtils, strutils, tables

proc markov(filePath: string; keySize, outputSize: Positive): string =

  let words = filePath.readFile().strip(false, true).splitWhitespace()
  doAssert outputSize in keySize..words.len, "Output size is out of range"

  var dict: Table[string, seq[string]]

  for i in 0..(words.len - keySize):
    let prefix = words[i..<(i+keySize)].join(" ")
    let suffix = if i + keySize < words.len: words[i + keySize] else: ""
    dict.mgetOrPut(prefix, @[]).add suffix

  var output: seq[string]
  var prefix = toSeq(dict.keys).sample()
  output.add prefix.split(' ')

  for n in 1..words.len:
    let nextWord = dict[prefix].sample()
    if nextWord.len == 0: break
    output.add nextWord
    if output.len >= outputSize: break
    prefix = output[n..<(n + keySize)].join(" ")

  result = output[0..<outputSize].join(" ")


const MaxLineSize = 100

randomize()
let result = markov("alice_oz.txt", 3, 100)
var start = 0
while start < result.len:
  var idx = if start + MaxLineSize <= result.high: result.rfind(' ', start, start + MaxLineSize)
            else: result.high
  if idx < 0: idx = result.high
  echo result[start..idx]
  start = idx + 1
