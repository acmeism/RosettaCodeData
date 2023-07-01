import std/strutils

let rawText = readFile("Traceback.txt")

for paragraph in rawText.split("\n\n"):
  if "SystemError" in paragraph:
    let index = paragraph.find("Traceback (most recent call last):")
    if index != -1:
      echo paragraph[index..^1]
      echo "----------------"
