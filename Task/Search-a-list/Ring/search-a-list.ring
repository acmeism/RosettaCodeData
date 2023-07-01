haystack = ["alpha","bravo","charlie","delta","echo","foxtrot","golf",
"hotel","india","juliet","kilo","lima","mike","needle",
"november","oscar","papa","quebec","romeo","sierra","tango",
"needle","uniform","victor","whisky","x-ray","yankee","zulu"]

needle = "needle"
maxindex = len(haystack)

for index = 1 to maxindex
    if needle = haystack[index] exit ok
next
if index <= maxindex
   see "first found at index " + index + nl ok
for last = maxindex to 0 step -1
    if needle = haystack[last] exit ok
next
if !=index see " last found at index " + last + nl
else see "not found" + nl ok
