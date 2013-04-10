|num1 num2 pseudoArr|
num1 := stdin nextLine asInteger.
num2 := stdin nextLine asInteger.

"we can 'suggest' an initial value for the number
 of ''slot'' the table can hold; anyway, if we use
 more than these, the table automatically grows"
pseudoArr := LookupTable new: (num1 * num2).

1 to: num1 do: [ :i |
  1 to: num2 do: [ :j |
     pseudoArr at: {i. j} put: (i * j).
  ]
].

1 to: num1 do: [ :i |
  1 to: num2 do: [ :j |
     (pseudoArr at: {i. j}) displayNl.
  ]
].
