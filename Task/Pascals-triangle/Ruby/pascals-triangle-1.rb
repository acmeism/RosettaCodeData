def pascal(n = 1)

  return if n < 1

  # set up a new array of arrays with the first value
  p = [[1]]

  # for n - 1 number of times,
  (n - 1).times do |i|

    # inject a new array starting with [1]
    p << p[i].inject([1]) do |result, elem|

      # if we've reached the end, tack on a 1.
      # else, tack on current elem + previous elem
      if p[i].length == result.length
        result << 1
      else
        result << elem + p[i][result.length]
      end
    end
  end

  # and return the triangle.
  p

end
