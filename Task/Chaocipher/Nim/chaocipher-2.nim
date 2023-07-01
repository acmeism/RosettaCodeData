import std/[algorithm, strutils]

type
  Mode = enum
    Encrypt
    Decrypt

const
  lAlphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
  rAlphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC"

proc chao(text: string; mode: Mode; verbose = false): string =
  var
    left = lAlphabet
    right = rAlphabet
    eText = newSeq[char](text.len)

  for i in 0 ..< text.len:
    if verbose:
      echo left, "  ", right
    var index: int
    if mode == Encrypt:
      index = right.find(text[i])
      eText[i] = left[index]
    else:
      index = left.find(text[i])
      eText[i] = right[index]
    if i == text.len - 1:
      break

    # permute left
    left.rotateLeft(index)
    left.rotateLeft(1..13, 1)

    # permute right
    right.rotateLeft(index + 1)
    right.rotateLeft(2..13, 1)

  result = eText.join()

let plainText = "WELLDONEISBETTERTHANWELLSAID"
echo "The original plaintext is: ", plainText
echo "\nThe left and right alphabets after each permutation during encryption are:\n"
let cipherText = chao(plainText, Encrypt, true)
echo "\nThe ciphertext is: ", cipherText
let plainText2 = chao(cipherText, Decrypt, false)
echo "\nThe recovered plaintext is: ", plainText2
