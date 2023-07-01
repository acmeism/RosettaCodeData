import strutils

echo "She was a soul stripper. She took my heart!".split({'a','e','i'}).join()

echo "She was a soul stripper. She took my heart!".multiReplace(
  ("a", ""),
  ("e", ""),
  ("i", "")
)

# And another way using module "sequtils".
import sequtils
echo "She was a soul stripper. She took my heart!".filterIt(it notin "aei").join()
