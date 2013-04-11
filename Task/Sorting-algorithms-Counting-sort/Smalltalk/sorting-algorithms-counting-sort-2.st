|ages|

ages := OrderedCollection new.

1 to: 100 do: [ :n |
    ages add: (Random between: 0 and: 140)
].

ages countingSortWithMin: 0 andMax: 140.
ages printNl.
