import sequtils, strutils

proc encrypt(key: seq[char]; msg: string): string =
  result.setLen(msg.len)
  for i, c in msg:
    result[i] = key[ord(c) - 32]

proc decrypt(key: seq[char]; msg: string): string =
  result.setLen(msg.len)
  for i, c in msg:
    result[i] = chr(key.find(c) + 32)

when isMainModule:

  import random
  randomize()

  # Build a random key.
  var key = toSeq(32..126).mapIt(chr(it))   # All printable characters.
  key.shuffle()

  const Message = "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"
  let encrypted = key.encrypt(Message)
  let decrypted = key.decrypt(encrypted)

  echo "Key =       “$#”" % key.join()
  echo "Message =   “$#”" % Message
  echo "Encrypted = “$#”" % encrypted
  echo "Decrypted = “$#”" % decrypted
