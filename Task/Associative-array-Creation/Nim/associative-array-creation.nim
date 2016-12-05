import tables

var
  hash = initTable[string, int]() # empty hash table
  hash2 = {"key1": 1, "key2": 2}.toTable # hash table with two keys
  hash3 = [("key1", 1), ("key2", 2)].toTable # hash table from tuple array
  hash4 = @[("key1", 1), ("key2", 2)].toTable # hash table from tuple seq
  value = hash2["key1"]

hash["spam"] = 1
hash["eggs"] = 2
hash.add("foo", 3)

echo "hash has ", hash.len, " elements"
echo "hash has key foo? ", hash.hasKey("foo")
echo "hash has key bar? ", hash.hasKey("bar")

echo "iterate pairs:" # iterating over (key, value) pairs
for key, value in hash:
  echo key, ": ", value

echo "iterate keys:" # iterating over keys
for key in hash.keys:
  echo key

echo "iterate values:" # iterating over values
for key in hash.values:
  echo key
