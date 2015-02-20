require 'matrix'

# Start with some matrix.
i = Complex::I
matrix = Matrix[[i, 0, 0],
                [0, i, 0],
                [0, 0, i]]

# Find the conjugate transpose.
#   Matrix#conjugate appeared in Ruby 1.9.2.
conjt = matrix.conj.t           # aliases for matrix.conjugate.tranpose
print 'conjugate tranpose: '; puts conjt

if matrix.square?
  # These predicates appeared in Ruby 1.9.3.
  print 'Hermitian? '; puts matrix.hermitian?
  print '   normal? '; puts matrix.normal?
  print '  unitary? '; puts matrix.unitary?
else
  # Matrix is not square. These predicates would
  # raise ExceptionForMatrix::ErrDimensionMismatch.
  print 'Hermitian? false'
  print '   normal? false'
  print '  unitary? false'
end
