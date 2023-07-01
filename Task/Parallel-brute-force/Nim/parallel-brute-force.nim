import strutils, threadpool
import nimcrypto

const

  # List of hexadecimal representation of target hashes.
  HexHashes = ["1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad",
               "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b",
               "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"]

  # List of target hashes.
  Hashes = [MDigest[256].fromHex(HexHashes[0]),
            MDigest[256].fromHex(HexHashes[1]),
            MDigest[256].fromHex(HexHashes[2])]

  Letters = 'a'..'z'


proc findHashes(a: char) =
  ## Build the arrays of five characters starting with the value
  ## of "a" and check if their hash matches one of the targets.
  ## Print the string and the hash value if a match is found.
  for b in Letters:
    for c in Letters:
      for d in Letters:
        for e in Letters:
          let s = [a, b, c, d, e]
          let h = sha256.digest(s)
          for i, target in Hashes:
            if h == target:   # Match.
              echo s.join(), " → ", HexHashes[i]


# Launch a thread for each starting character.
for a in Letters:
  spawn findHashes(a)

sync()
