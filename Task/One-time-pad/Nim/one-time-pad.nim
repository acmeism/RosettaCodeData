import os, re, sequtils, strformat, strutils
import nimcrypto

# One-time pad file signature.
const Magic = "#one-time pad"

# Suffix for pad files.
const Suffix = ".1tp"

proc log(msg: string) =
  ## Log a message.
  stderr.write msg
  stderr.write '\n'

proc makeKeys(n, size: Positive): seq[string] =
  ## Generate "n" secure, random keys of "size" bytes.

  # We're generating and storing keys in their hexadecimal form to make
  # one-time pad files a little more human readable and to ensure a key
  # can not start with a hyphen.
  var bytes = newSeq[byte](size)
  for _ in 1..n:
    if randomBytes(bytes) != size:
      raise newException(ValueError, "unable to build keys.")
    result.add bytes.mapIt(it.toHex).join()

proc makePad(name: string; padSize, keySize: Positive): string =
  ## Create a new one-time pad identified by the given name.
  ## Args:
  ##     name: unique one-time pad identifier.
  ##     padSize: the number of keys (or pages) in the pad.
  ##     keySize: the number of bytes per key.
  ## Returns:
  ##     the new one-time pad as a string.

  let pad = @[Magic, &"#name={name}", &"#size={padSize}"] & makeKeys(padSize, keySize)
  result = pad.join("\n")

proc `xor`(message, key: string): string =
  ## Return "message" XOR-ed with "key".
  ##
  ## Args:
  ##     message: plaintext or cyphertext to be encrypted or decrypted.
  ##     key: encryption and decryption key.
  ## Returns:
  ##     plaintext or cyphertext as a string.

  if key.len < message.len:
    quit("Key size is too short to encrypt/decrypt the message.", QuitFailure)
  result = newStringOfCap(message.len)
  var keyIndex = 0
  for msgChar in message:
    result.add chr(ord(msgChar) xor ord(key[keyIndex]))
    inc keyIndex

proc useKey(pad: var string): string =
  ## Use the next available key from the given one-time pad.
  ##
  ## Args:
  ##     pad: a one-time pad, updated.
  ## Returns:
  ##     the key.

  var matches: array[1, string]
  let pos = pad.find(re"(?m)(^[A-F0-9]+$)", matches)
  if pos < 0:
    quit("Pad is all used up.", QuitFailure)

  pad.insert("-", pos)
  result = matches[0]

proc writePad(path: string; padSize, keySize: Positive) =
  ## Write a new one-time pad to the given path.
  ##
  ## Args:
  ##     path: path to write one-time pad to.
  ##     padSize: the number of keys (or pages) in the pad.
  ##     keySize: the number of bytes per key.

  if fileExists(path):
    quit("Pad " & path & " already exists", QuitFailure)
  try:
    path.writeFile(makePad(path.extractFilename(), padSize, keySize))
  except IOError:
    quit("Unable to write file " & path, QuitFailure)
  log("New one-time pad written to " & path)

proc process(pad, message: string; outfile: File) =
  ## Encrypt or decrypt "message" using the given pad.
  ##
  ## Args:
  ##     pad: path to one-time pad.
  ##     message: plaintext or ciphertext message to encrypt or decrypt.
  ##     outfile: file-like object to write to.

  if not fileExists(pad):
    quit("No such pad: " & pad, QuitFailure)
  let start = pad.readLines(1)
  if start.len == 0 or start[0] != Magic:
    quit(&"file '{pad}' does not look like a one-time pad", QuitFailure)

  # Rewrites the entire one-time pad every time
  var padData = pad.readFile()
  let key = padData.useKey().parseHexStr()
  pad.writeFile(padData)

  outfile.write(message xor key)


when isMainModule:

  import parseopt

  proc printUsage() =
    echo "Usage: ", getAppFilename().lastPathPart,
         " [-h] [--length LENGTH] [--key-size KEY_SIZE] [-o OUTFILE]"
    echo "                    [--encrypt FILE | --decrypt FILE] pad"
    echo ""
    echo """One-time pad.

positional arguments:
  pad                   Path to one-time pad. If neither --encrypt or --decrypt
                        are given, will create a new pad.

optional arguments:
  -h, --help            show this help message and exit
  --length LENGTH       Pad size. Ignored if --encrypt or --decrypt are given.
                        Defaults to 10.
  --key-size KEY_SIZE   Key size in bytes. Ignored if --encrypt or --decrypt
                        are given. Defaults to 64.
  --outfile OUTFILE     Write encoded/decoded message to a file. Ignored if
                        --encrypt or --decrypt is not given. Defaults to
                        stdout.
  --encrypt FILE        Encrypt FILE using the next available key from pad.
  --decrypt FILE        Decrypt FILE using the next available key from pad.
  """

  var
    parser = initOptParser(shortNoVal = {'h'}, longNoval = @["help"])
    padPath: string
    length = 10
    outpath = ""
    encryptPath = ""
    decryptPath = ""
    keySize = 64
    encrypt = false
    decrypt = false

  for kind, key, val in parser.getopt():
    case kind

    of cmdShortOption:
      printUsage()
      if key != "h":
        quit("Wrong option: " & key, QuitFailure)
      elif val.len != 0:
        quit("Wrong value for option -h", QuitFailure)
      else:
        quit(QuitSuccess)

    of cmdLongOption:
      case key

      of "help":
        printUsage()
        quit(QuitSuccess)

      of "length":
        try:
          length = parseInt(val)
          if length < 2: raise newException(ValueError, "")
        except ValueError:
          quit("Wrong length: " & val, QuitFailure)

      of "encrypt":
        encryptPath = val
        encrypt = true

      of "decrypt":
        decryptPath = val
        decrypt = true

      of "outfile":
        outPath = val

      of "key-size":
        try:
          keySize = parseInt(val)
          if length < 2: raise newException(ValueError, "")
        except ValueError:
          quit("Wrong key size: " & val, QuitFailure)

      else:
        quit("Invalid option: " & key, QuitFailure)

    of cmdArgument:
      padPath = if key.endsWith(Suffix): key else: key & Suffix

    of cmdEnd:
      discard   # Cannot not occur.

  if padPath.len == 0:
    quit("Missing pad file.", QuitFailure)

  if encrypt and decrypt:
    quit("Incompatible options: encrypt and decrypt", QuitFailure)

  if encrypt or decrypt:

    var outfile: File
    if outpath.len == 0:
      outfile = stdout
    else:
      try:
        outfile = outpath.open(fmWrite)
      except IOError:
        quit("Unable to open output file.", QuitFailure)

    let message = try:
                    if encrypt: encryptPath.readFile()
                    else: decryptPath.readFile()
                  except IOError:
                    quit("Unable to open file to encrypt or decrypt.", QuitFailure)

    padPath.process(message, outfile)
    if outfile != stdout: outfile.close()

  else:
    padPath.writePad(length, keySize)
