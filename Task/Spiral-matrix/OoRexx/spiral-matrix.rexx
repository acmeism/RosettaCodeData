call printArray generateArray(3)
say
call printArray generateArray(4)
say
call printArray generateArray(5)

::routine generateArray
  use arg dimension
  -- the output array
  array = .array~new(dimension, dimension)

  -- get the number of squares, including the center one if
  -- the dimension is odd
  squares = dimension % 2 + dimension // 2
  -- length of a side for the current square
  sidelength = dimension
  current = 0
  loop i = 1 to squares
      -- do each side of the current square
      -- top side
      loop j = 0 to sidelength - 1
          array[i, i + j] = current
          current += 1
      end
      -- down the right side
      loop j = 1 to sidelength - 1
          array[i + j, dimension - i + 1] = current
          current += 1
      end
      -- across the bottom
      loop j = sidelength - 2 to 0 by -1
          array[dimension - i + 1, i + j] = current
          current += 1
      end
      -- and up the left side
      loop j = sidelength - 2 to 1 by -1
          array[i + j, i] = current
          current += 1
      end
      -- reduce the length of the side by two rows
      sidelength -= 2
  end
  return array

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
