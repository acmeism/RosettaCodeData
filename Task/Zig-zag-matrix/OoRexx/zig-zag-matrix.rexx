call printArray zigzag(3)
say
call printArray zigzag(4)
say
call printArray zigzag(5)

::routine zigzag
  use strict arg size

  data = .array~new(size, size)
  row = 1
  col = 1

  loop element = 0 to (size * size) - 1
      data[row, col] = element
      -- even stripes
      if (row + col) // 2 = 0 then do
          if col < size then col += 1
          else row += 2
          if row > 1 then row -= 1
      end
      -- odd rows
      else do
          if row < size then row += 1
          else col += 2
          if col > 1 then col -= 1
      end
  end

  return data

::routine printArray
  use arg array
  dimension = array~dimension(1)
  loop i = 1 to dimension
      line = "|"
      loop j = 1 to dimension
          line = line array[i, j]~right(2)
      end
      line = line "|"
      say line
   end
