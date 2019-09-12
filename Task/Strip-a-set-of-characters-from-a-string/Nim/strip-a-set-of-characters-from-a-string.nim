import strutils

echo "She was a soul stripper. She took my heart!".split({'a','e','i'}).join()

echo "She was a soul stripper. She took my heart!".multiReplace(
  ("a", ""),
  ("e", ""),
  ("i", "")
)
