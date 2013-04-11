assert string == stringRef           // they have equal values (like Java equals(), not like Java ==)
assert string.is(stringRef)          // they are references to the same objext (like Java ==)
assert string == stringCopy          // they have equal values
assert ! string.is(stringCopy)       // they are references to different objects (like Java !=)
