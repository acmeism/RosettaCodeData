set_property(GLOBAL PROPERTY fibonacci_0 0)
set_property(GLOBAL PROPERTY fibonacci_1 1)
set_property(GLOBAL PROPERTY fibonacci_next 2)

# var = nth number in Fibonacci sequence.
function(fibonacci var n)
  # If the sequence is too short, compute more Fibonacci numbers.
  get_property(next GLOBAL PROPERTY fibonacci_next)
  if(NOT next GREATER ${n})
    # a, b = last 2 Fibonacci numbers
    math(EXPR i "${next} - 2")
    get_property(a GLOBAL PROPERTY fibonacci_${i})
    math(EXPR i "${next} - 1")
    get_property(b GLOBAL PROPERTY fibonacci_${i})

    while(NOT next GREATER ${n})
      math(EXPR i "${a} + ${b}")  # i = next Fibonacci number
      set_property(GLOBAL PROPERTY fibonacci_${next} ${i})
      set(a ${b})
      set(b ${i})
      math(EXPR next "${next} + 1")
    endwhile()
    set_property(GLOBAL PROPERTY fibonacci_next ${next})
  endif()

  get_property(answer GLOBAL PROPERTY fibonacci_${n})
  set(${var} ${answer} PARENT_SCOPE)
endfunction(fibonacci)
