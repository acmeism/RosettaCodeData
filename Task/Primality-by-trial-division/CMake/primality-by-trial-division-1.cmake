# Prime predicate: does n be a prime number? Sets var to true or false.
function(primep var n)
  if(n GREATER 2)
    math(EXPR odd "${n} % 2")
    if(odd)
      # n > 2 and n is odd.
      set(factor 3)
      # Loop for odd factors from 3, while factor <= n / factor.
      math(EXPR quot "${n} / ${factor}")
      while(NOT factor GREATER quot)
        math(EXPR rp "${n} % ${factor}")        # Trial division
        if(NOT rp)
          # factor divides n, so n is not prime.
          set(${var} false PARENT_SCOPE)
          return()
        endif()
        math(EXPR factor "${factor} + 2")       # Next odd factor
        math(EXPR quot "${n} / ${factor}")
      endwhile(NOT factor GREATER quot)
      # Loop found no factor, so n is prime.
      set(${var} true PARENT_SCOPE)
    else()
      # n > 2 and n is even, so n is not prime.
      set(${var} false PARENT_SCOPE)
    endif(odd)
  elseif(n EQUAL 2)
    set(${var} true PARENT_SCOPE)       # 2 is prime.
  else()
    set(${var} false PARENT_SCOPE)      # n < 2 is not prime.
  endif()
endfunction(primep)
