# insertion_sort(var [value1 value2...]) sorts a list of integers.
function(insertion_sort var)
  math(EXPR last "${ARGC} - 1")         # Sort ARGV[1..last].
  foreach(i RANGE 1 ${last})
    # Extend the sorted area to ARGV[1..i].
    set(b ${i})
    set(v ${ARGV${b}})
    # Insert v == ARGV[b] in sorted order. While b > 1, check if b is
    # too high, then decrement b. After loop, set ARGV[b] = v.
    while(b GREATER 1)
      math(EXPR a "${b} - 1")
      set(u ${ARGV${a}})
      # Now u == ARGV[a]. Pretend v == ARGV[b]. Compare.
      if(u GREATER ${v})
        # ARGV[a] and ARGV[b] are in wrong order. Fix by moving ARGV[a]
        # to ARGV[b], making room for later insertion of v.
        set(ARGV${b} ${u})
      else()
        break()
      endif()
      math(EXPR b "${b} - 1")
    endwhile()
    set(ARGV${b} ${v})
  endforeach(i)

  set(answer)
  foreach(i RANGE 1 ${last})
    list(APPEND answer ${ARGV${i}})
  endforeach(i)
  set("${var}" "${answer}" PARENT_SCOPE)
endfunction(insertion_sort)
