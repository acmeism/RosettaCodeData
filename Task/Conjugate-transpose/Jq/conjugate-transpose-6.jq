def hermitian_example:
  [ [ 3,    [2,1]],
    [[2,-1], 1   ] ];

def normal_example:
  [ [1, 1, 0],
    [0, 1, 1],
    [1, 0, 1] ];

def unitary_example:
  0.707107
  |  [ [ [., 0], [.,  0],   0 ],
       [ [0, -.], [0, .],   0 ],
       [ 0,      0,      [0,1] ] ];

def demo:
  hermitian_example
  | ("Hermitian example:", pp(8)),
    "",
    ("Its conjugate transpose is:",  (to_complex | conjugate_transpose | pp(8))),
    "",
    "Hermitian example: \(hermitian_example | is_hermitian )",
    "",
    "Normal example:    \(normal_example    | is_normal )",
    "",
    "Unitary example:   \(unitary_example   | is_unitary)"
;

demo
