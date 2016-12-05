# A|lup|verify(A) should be true
def verify(A):
  .[0] as $L | .[1] as $U | .[2] as $P
  | multiply($P; A) == multiply($L; $U);

def A:
  [[1,  1,  1,  1],
   [1,  1, -1, -1],
   [1, -1,  0,  0],
   [0,  0,  1, -1]];

A|lup|verify(A)
