|num1 num2 arr|
num1 := stdin nextLine asInteger.
num2 := stdin nextLine asInteger.

arr := MultidimensionalArray new: { num1. num2 }.

1 to: num1 do: [ :i |
  1 to: num2 do: [ :j |
    arr at: { i. j } put: (i*j)
  ]
].

1 to: num1 do: [ :i |
  1 to: num2 do: [ :j |
    (arr at: {i. j}) displayNl
  ]
].
