stones, jewels = "aAAbbbb", "aA"
stones.count(jewels) # => 3

# The above solution works for that case, but fails with certain other "jewels":
stones, jewels = "aA^Bb", "^b"
stones.count(jewels) # => 4
# '^b' in the "jewels" is read as "characters other than 'b'".

# This works as intended though:
stones.count { |c| jewels.chars.includes?(c) } # => 2
