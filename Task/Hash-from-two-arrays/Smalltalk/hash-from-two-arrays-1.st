Array extend [
  dictionaryWithValues: array [ |d|
    d := Dictionary new.
    1 to: ((self size) min: (array size)) do: [:i|
      d at: (self at: i) put: (array at: i).
    ].
    ^ d
  ]
].


({ 'red' . 'one' . 'two' }
 dictionaryWithValues: { '#ff0000'. 1. 2 }) displayNl.
