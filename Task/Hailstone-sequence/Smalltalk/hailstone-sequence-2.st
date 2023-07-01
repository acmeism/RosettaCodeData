|r|
r := Sequences hailstone: 27.  "hailstone 'from' 27"
(r size) displayNl.            "its length"

"test 'head' ..."
( (r first: 4) = #( 27  82  41  124 ) asOrderedCollection ) displayNl.

"... and 'tail'"
( ( (r last: 4 ) ) = #( 8 4 2 1 ) asOrderedCollection) displayNl.

|longest|
longest := OrderedCollection from: #( 1 1 ).
2 to: 100000 do: [ :c |
  |l|
  l := Sequences hailstoneCount: c.
  (l > (longest at: 2) ) ifTrue: [ longest replaceFrom: 1 to: 2 with: { c . l }  ].
].

('Sequence generator %1, sequence length %2' % { (longest at: 1) . (longest at: 2) })
   displayNl.
