import std/[os, parseopt, strformat, strutils]

const
  BytesHex = 16
  BytesBin = 6

proc printHex(data: openArray[byte]; count: int) =
  for i in 0..<count:
    if i mod 8 == 0: stdout.write ' '
    stdout.write &" {data[i]:02x}"
  for i in count..<BytesHex:
    if i mod 8 == 0: stdout.write ' '
    stdout.write "   "

proc printBinary(data: openArray[byte]; count: int) =
  stdout.write ' '
  for i in 0..<count:
    let c = data[i]
    stdout.write ' '
    for j in countdown(7, 0):
      let m = 1u8 shl j
      stdout.write ord((c and m) != 0)
  for _ in count..<BytesBin:
    stdout.write "         "

proc printChars(data: openArray[byte]; count: int) =
  for i in 0..<count:
    let c = chr(data[i])
    stdout.write (if c in ' '..'~': c else: '.')

proc usage() =
  stderr.writeLine &"usage: {getAppFilename()} [-b] [-s skip] [-n length] filename"

proc usageError(err = "", arg = "") =
  if err.len > 0 and arg.len > 0:
    stderr.writeLine &"{err} {arg}."
    usage()
  quit QuitFailure


var binary = false
var offset = 0i64
var maxLength = int64.high
var filename = ""
for kind, key, val in getopt(shortNoVal = {'b'}):
  case kind
  of cmdArgument:
    filename = key
  of cmdShortOption:
    case key
    of "b":
      binary = true
    of "s":
      if val.len == 0: usageError()
      try: offset = parseUint(val).int64
      except ValueError: usageError(&"Invalid skip: {val}")
    of "n":
      if val.len == 0: usageError()
      try: maxLength = parseUint(val).int64
      except ValueError: usageError(&"Invalid length: {val}")
    else:
      usageError()
  of cmdLongOption:
    usageError()
  of cmdEnd: assert(false)  # Cannot happen.

if filename.len == 0: usageError()

var data: array[BytesHex, byte]

var file: File
try: file = open(filename)
except IOError: usageError(&"Cannot open \"{filename}\" for reading.")

if offset > 0:
  offset = min(offset, file.getFileSize())
file.setFilePos(offset, fspSet)

var length = 0i64
let maxCount = if binary: BytesBin else: BytesHex
while length < maxLength:
  stdout.write &"{offset:08x}"
  var count = file.readBytes(data, 0, maxCount)
  if count > maxLength - length:
    count = maxLength - length
  elif count == 0:
    echo()
    break
  if binary: printBinary(data, count)
  else: printHex(data, count)
  stdout.write "  |"
  printChars(data, count)
  echo "|"
  inc offset, count
  inc length, count

file.close()
