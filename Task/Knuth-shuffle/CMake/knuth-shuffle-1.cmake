# shuffle(<output variable> [<value>...]) shuffles the values, and
# stores the result in a list.
function(shuffle var)
  set(forever 1)

  # Receive ARGV1, ARGV2, ..., ARGV${last} as an array of values.
  math(EXPR last "${ARGC} - 1")

  # Shuffle the array with Knuth shuffle (Fisher-Yates shuffle).
  foreach(i RANGE ${last} 1)
    # Roll j = a random number from 1 to i.
    math(EXPR min "100000000 % ${i}")
    while(forever)
      string(RANDOM LENGTH 8 ALPHABET 0123456789 j)
      if(NOT j LESS min)        # Prevent modulo bias when j < min.
        break()                 # Break loop when j >= min.
      endif()
    endwhile()
    math(EXPR j "${j} % ${i} + 1")

    # Swap ARGV${i} with ARGV${j}.
    set(t ${ARGV${i}})
    set(ARGV${i} ${ARGV${j}})
    set(ARGV${j} ${t})
  endforeach(i)

  # Convert array to list.
  set(answer)
  foreach(i RANGE 1 ${last})
    list(APPEND answer ${ARGV${i}})
  endforeach(i)
  set("${var}" ${answer} PARENT_SCOPE)
endfunction(shuffle)
