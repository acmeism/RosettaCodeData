def read_matrix(data)
  lines = data.each_line.to_a                   # ver 2.0 later  data.lines
  9.times.collect { |i| 9.times.collect { |j| lines[i][j].to_i } }
end

def permissible(matrix, i, j)
  ok = [nil, *1..9]
  # Same as another in the column isn't permissible...
  9.times do |i2|
    ok[matrix[i2][j]] = nil if matrix[i2][j].nonzero?
  end
  # Same as another in the row isn't permissible...
  9.times do |j2|
    ok[matrix[i][j2]] = nil if matrix[i][j2].nonzero?
  end
  # Same as another in the 3x3 block isn't permissible...
  irange = (ig = (i / 3) * 3) .. ig + 2
  jrange = (jg = (j / 3) * 3) .. jg + 2
  irange.each do |i2|
    jrange.each do |j2|
      ok[matrix[i2][j2]] = nil if matrix[i2][j2].nonzero?
    end
  end
  # Gathering only permitted one
  ok.compact
end

def deep_copy_sudoku(matrix)
  matrix.collect { |row| row.dup }
end

def solve_sudoku(matrix)
  loop do
    options = []
    9.times do |i|
      9.times do |j|
        next if matrix[i][j].nonzero?
        p = permissible(matrix, i, j)
        # If nothing is permissible, there is no solution at this level.
        return if p.empty?              # return nil
        options << [i, j, p]
      end
    end
    # If the matrix is complete, we have a solution...
    return matrix if options.empty?

    i, j, permissible = options.min_by { |x| x.last.length }

    # If there is an option with only one solution, set it and re-check permissibility
    if permissible.length == 1
      matrix[i][j] = permissible[0]
      next
    end

    # We have two or more choices. We need to search both...
    permissible.each do |v|
      mtmp = deep_copy_sudoku(matrix)
      mtmp[i][j] = v
      ret = solve_sudoku(mtmp)
      return ret if ret
    end

    # We did an exhaustive search on this branch and nothing worked out.
    return
  end
end

def print_matrix(matrix)
  puts "Impossible" or return  unless matrix

  border = "+-----+-----+-----+"
  9.times do |i|
    puts border if i%3 == 0
    9.times do |j|
      print j%3 == 0 ? "|" : " "
      print matrix[i][j] == 0 ? "." : matrix[i][j]
    end
    puts "|"
  end
  puts border
end

data = <<EOS
394__267_
___3__4__
5__69__2_
_45___9__
6_______7
__7___58_
_1__67__8
__9__8___
_264__735
EOS

matrix = read_matrix(data)
print_matrix(matrix)
puts
print_matrix(solve_sudoku(matrix))
