import sequtils

func countJewels(stones, jewels: string): Natural =
  stones.countIt(it in jewels)

echo countJewels("aAAbbbb", "aA")
echo countJewels("ZZ", "z")
