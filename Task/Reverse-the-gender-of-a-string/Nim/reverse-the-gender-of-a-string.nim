import re, strutils

const
  Words = ["She", "she", "Her",  "her",  "hers", "He",   "he",   "His",  "his",  "him"]
  Repls = ["He_", "he_", "His_", "his_" ,"his_", "She_", "she_", "Her_", "her_", "her_"]

func reverseGender(s: string): string =
  result = s
  for i, word in Words:
    let r = re(r"\b" & word & r"\b")
    result = result.replace(r, Repls[i])
  result = result.replace("_", "")

echo reverseGender("She was a soul stripper. She took his heart!")
echo reverseGender("He was a soul stripper. He took her heart!")
echo reverseGender("She wants what's hers, he wants her and she wants him!")
echo reverseGender("Her dog belongs to him but his dog is hers!")
