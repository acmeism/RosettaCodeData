function(eratosthenes var limit)
  # Check for integer overflow. With CMake using 32-bit signed integer,
  # this check fails when limit > 46340.
  if(NOT limit EQUAL 0)         # Avoid division by zero.
    math(EXPR i "(${limit} * ${limit}) / ${limit}")
    if(NOT limit EQUAL ${i})
      message(FATAL_ERROR "limit is too large, would cause integer overflow")
    endif()
  endif()

  # Use local variables prime_2, prime_3, ..., prime_${limit} as array.
  # Initialize array to y => yes it is prime.
  foreach(i RANGE 2 ${limit})
    set(prime_${i} y)
  endforeach(i)

  # Gather a list of prime numbers.
  set(list)
  foreach(i RANGE 2 ${limit})
    if(prime_${i})
      # Append this prime to list.
      list(APPEND list ${i})

      # For each multiple of i, set n => no it is not prime.
      # Optimization: start at i squared.
      math(EXPR square "${i} * ${i}")
      if(NOT square GREATER ${limit})   # Avoid fatal error.
        foreach(m RANGE ${square} ${limit} ${i})
          set(prime_${m} n)
        endforeach(m)
      endif()
    endif(prime_${i})
  endforeach(i)
  set(${var} ${list} PARENT_SCOPE)
endfunction(eratosthenes)
