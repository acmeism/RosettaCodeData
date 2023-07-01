say "a 3x3 identity matrix"
say
call printMatrix createIdentityMatrix(3)
say
say "a 5x5 identity matrix"
say
call printMatrix createIdentityMatrix(5)

::routine createIdentityMatrix
  use arg size
  matrix = .array~new(size, size)
  loop i = 1 to size
      loop j = 1 to size
          if i == j then matrix[i, j] = 1
          else matrix[i, j] = 0
      end j
  end i
  return matrix

::routine printMatrix
  use arg matrix

  loop i = 1 to matrix~dimension(1)
      line = ""
      loop j = 1 to matrix~dimension(2)
          line = line matrix[i, j]
      end j
      say line
  end i
