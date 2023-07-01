|happy|
happy := HappyNumber new.

1 to: 31 do: [ :i |
  (happy isHappy: i)
  ifTrue: [ i displayNl ]
].
