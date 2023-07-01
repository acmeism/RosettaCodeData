def countJewels(stones, jewels):
    jewelset = set(jewels)
    return sum(1 for stone in stones if stone in jewelset)

print(countJewels("aAAbbbb", "aA"))
print(countJewels("ZZ", "z"))
