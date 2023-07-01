import os, parseopt, random, sequtils, strformat, strutils

const Symbols = toSeq("!\"#$%&'()*+,-./:;<=>?@[]^_{|}~")


proc passGen(passLength = 10,
             count = 1,
             seed = 0,
             excludeSimilars = false): seq[string] =
  ## Generate a sequence of passwords.

  # Initialize the random number generator.
  if seed == 0: randomize()
  else: randomize(seed)

  # Prepare list of chars per category.
  var
    lowerLetters = toSeq('a'..'z')
    upperLetters = toSeq('A'..'Z')
    digits = toSeq('0'..'9')

  if excludeSimilars:
    lowerLetters.delete(lowerLetters.find('l'))
    for c in "IOSZ": upperLetters.delete(upperLetters.find(c))
    for c in "012": digits.delete(digits.find(c))

  let all = lowerLetters & upperLetters & digits & Symbols

  # Generate the passwords.
  for _ in 1..count:
    var password = newString(passLength)
    password[0] = lowerLetters.sample
    password[1] = upperLetters.sample
    password[2] = digits.sample
    password[3] = Symbols.sample
    for i in 4..<passLength:
      password[i] = all.sample
    password.shuffle()
    result.add password


proc printHelp() =
  ## Print the help message.
  echo &"Usage: {getAppFileName().lastPathPart} " &
        "[-h] [-l:length] [-c:count] [-s:seed] [-x:(true|false)]"
  echo "  -h: display this help"
  echo "  -l: length of generated passwords"
  echo "  -c: number of passwords to generate"
  echo "  -s: seed for the random number generator"
  echo "  -x: exclude similar characters"


proc getIntValue(key, val: string): int =
  ## Get a positive integer value from a string.
  try:
    result = val.parseInt()
    if result <= 0:
      raise newException(ValueError, "")
  except ValueError:
    quit &"Wrong value for option -{key}: {val}", QuitFailure


var
  passLength = 10
  count = 1
  seed = 0
  excludeSimilars = false

# Process options.
var parser = initOptParser()

for kind, key, val in parser.getopt():
  if kind != cmdShortOption:
    printHelp()
    quit(QuitFailure)

  case key
  of "h":
    printHelp()
    quit(QuitSuccess)
  of "l":
    passLength = getIntValue(key, val)
  of "c":
    count = getIntValue(key, val)
  of "s":
    seed = getIntValue(key, val)
  of "x":
    if val.toLowerAscii == "true":
      excludeSimilars = true
    elif val.toLowerAscii == "false":
      excludeSimilars = false
    else:
      quit &"Wrong value for option -x: {val}", QuitFailure
  else:
    quit &"Wrong option: -{key}"

# Display the passwords.
for pw in passGen(passLength, count, seed, excludeSimilars):
  echo pw
