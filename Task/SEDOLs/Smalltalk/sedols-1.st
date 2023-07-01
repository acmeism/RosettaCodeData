String extend [
  includesAnyOf: aSet [
      aSet do: [ :e | (self includes: e) ifTrue: [ ^true ] ].
      ^false
  ]
].
