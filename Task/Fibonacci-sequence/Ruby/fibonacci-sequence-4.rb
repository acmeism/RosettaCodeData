require 'matrix'

# To understand why this matrix is useful for Fibonacci numbers, remember
# that the definition of Matrix.**2 for any Matrix[[a, b], [c, d]] is
# is [[a*a + b*c, a*b + b*d], [c*a + d*b, c*b + d*d]].  In other words, the
# lower right element is computing F(k - 2) + F(k - 1) every time M is multiplied
# by itself (it is perhaps easier to understand this by computing M**2, 3, etc, and
# watching the result march up the sequence of Fibonacci numbers).

M = Matrix[[0, 1], [1,1]]

# Matrix exponentiation algorithm to compute Fibonacci numbers.
# Let M be Matrix [[0, 1], [1, 1]].  Then, the lower right element of M**k is
# F(k + 1).  In other words, the lower right element of M is F(2) which is 1, and the
# lower right element of M**2 is F(3) which is 2, and the lower right element
# of M**3 is F(4) which is 3, etc.
#
# This is a good way to compute F(n) because the Ruby implementation of Matrix.**(n)
# uses O(log n) rather than O(n) matrix multiplications.  It works by squaring squares
# ((m**2)**2)... as far as possible
# and then multiplying that by by M**(the remaining number of times).  E.g., to compute
# M**19, compute partial = ((M**2)**2) = M**16, and then compute partial*(M**3) = M**19.
# That's only 5 matrix multiplications of M to compute M*19.
def self.fibMatrix(n)
  return 0 if n <= 0 # F(0)
  return 1 if n == 1 # F(1)
  # To get F(n >= 2), compute M**(n - 1) and extract the lower right element.
  return CS::lower_right(M**(n - 1))
end

# Matrix utility to return
# the lower, right-hand element of a given matrix.
def self.lower_right matrix
  return nil if matrix.row_size == 0
  return matrix[matrix.row_size - 1, matrix.column_size - 1]
end
