import arraymancer

let c = [
          [
            [1,2,3],
            [4,5,6]
          ],
          [
            [11,22,33],
            [44,55,66]
          ],
          [
            [111,222,333],
            [444,555,666]
          ],
          [
            [1111,2222,3333],
            [4444,5555,6666]
          ]
        ].toTensor()

echo c
# Tensor of shape 4x2x3 of type "int" on backend "Cpu"
#  |      1       2       3 |     11      22      33 |    111     222     333 |   1111    2222    3333|
#  |      4       5       6 |     44      55      66 |    444     555     666 |   4444    5555    6666|

let e = newTensor[bool]([2, 3])

echo e
# Tensor of shape 2x3 of type "bool" on backend "Cpu"
# |false  false   false|
# |false  false   false|

let f = zeros[float]([4, 3])

echo f
# Tensor of shape 4x3 of type "float" on backend "Cpu"
# |0.0    0.0     0.0|
# |0.0    0.0     0.0|
# |0.0    0.0     0.0|
# |0.0    0.0     0.0|

let g = ones[float]([4, 3])

echo g
# Tensor of shape 4x3 of type "float" on backend "Cpu"
# |1.0    1.0     1.0|
# |1.0    1.0     1.0|
# |1.0    1.0     1.0|
# |1.0    1.0     1.0|
