# bubble_sort(var [value1 value2...]) sorts a list of integers.
function(bubble_sort var)
  math(EXPR last "${ARGC} - 1")  # Prepare to sort ARGV[1]..ARGV[last].
  set(again YES)
  while(again)
    set(again NO)
    math(EXPR last "${last} - 1")               # Decrement last index.
    foreach(index RANGE 1 ${last})              # Loop for each index.
      math(EXPR index_plus_1 "${index} + 1")
      set(a "${ARGV${index}}")                  # a = ARGV[index]
      set(b "${ARGV${index_plus_1}}")           # b = ARGV[index + 1]
      if(a GREATER "${b}")                      # If a > b...
        set(ARGV${index} "${b}")                # ...then swap a, b
        set(ARGV${index_plus_1} "${a}")         #    inside ARGV.
        set(again YES)
      endif()
    endforeach(index)
  endwhile()

  set(answer)
  math(EXPR last "${ARGC} - 1")
  foreach(index RANGE 1 "${last}")
    list(APPEND answer "${ARGV${index}}")
  endforeach(index)
  set("${var}" "${answer}" PARENT_SCOPE)
endfunction(bubble_sort)
