|pairs|
pairs := Dictionary
	    from: { 'hello' -> 1. 'world' -> 2. '!' -> 3. 'another!' -> 3 }.

"iterate over keys and values"
pairs keysAndValuesDo: [ :k :v |
    ('(k, v) = (%1, %2)' % { k. v }) displayNl
].

"iterate over keys"
pairs keysDo: [ :key |
    ('key = %1, value = %2' % { key. pairs at: key }) displayNl
].

"iterate over values"
pairs do: [ :value |
    ('value = %1' % { value }) displayNl
].
