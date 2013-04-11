|r o|
r := Random new.
o := OrderedCollection new.

1 to: 10 do: [ :i | o add: (r between: 0 and: 50) ].

gnomesort value: o.

1 to: 10 do: [ :i | (o at: i) displayNl ].
