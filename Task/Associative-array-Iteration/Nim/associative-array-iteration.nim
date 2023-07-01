import tables

var t: Table[int,string]

t[1] = "one"
t[2] = "two"
t[3] = "three"
t[4] = "four"

echo "t has " & $t.len & " elements"

echo "has t key 4? " & $t.hasKey(4)
echo "has t key 5? " & $t.hasKey(5)

#iterate keys
echo "key iteration:"
for k in t.keys:
  echo "at[" & $k & "]=" & t[k]

#iterate pairs
echo "pair iteration:"
for k,v in t.pairs:
  echo "at[" & $k & "]=" & v
