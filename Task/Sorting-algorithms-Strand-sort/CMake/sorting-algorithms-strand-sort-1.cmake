# strand_sort(<output variable> [<value>...]) sorts a list of integers.
function(strand_sort var)
  # Strand sort moves elements from _ARGN_ to _answer_.
  set(answer)                   # answer: a sorted list
  while(DEFINED ARGN)
    # Split _ARGN_ into two lists, _accept_ and _reject_.
    set(accept)                 # accept: elements in sorted order
    set(reject)                 # reject: all other elements
    set(p)
    foreach(e ${ARGN})
      if(DEFINED p AND p GREATER ${e})
        list(APPEND reject ${e})
      else()
        list(APPEND accept ${e})
        set(p ${e})
      endif()
    endforeach(e)

    # Prepare to merge _accept_ into _answer_. First, convert both lists
    # into arrays, for better indexing: set(e ${answer${i}}) is faster
    # than list(GET answer ${i} e).
    set(la 0)
    foreach(e ${answer})
      math(EXPR la "${la} + 1")
      set(answer${la} ${e})
    endforeach(e)
    set(lb 0)
    foreach(e ${accept})
      math(EXPR lb "${lb} + 1")
      set(accept${lb} ${e})
    endforeach(e)

    # Merge _accept_ into _answer_.
    set(answer)
    set(ia 1)
    set(ib 1)
    while(NOT ia GREATER ${la})         # Iterate elements of _answer_.
      set(ea ${answer${ia}})
      while(NOT ib GREATER ${lb})       # Take elements from _accept_,
        set(eb ${accept${ib}})          #   while they are less than
        if(eb LESS ${ea})               #   next element of _answer_.
          list(APPEND answer ${eb})
          math(EXPR ib "${ib} + 1")
        else()
          break()
        endif()
      endwhile()
      list(APPEND answer ${ea})         # Take next from _answer_.
      math(EXPR ia "${ia} + 1")
    endwhile()
    while(NOT ib GREATER ${lb})         # Take rest of _accept_.
      list(APPEND answer ${accept${ib}})
      math(EXPR ib "${ib} + 1")
    endwhile()

    # This _reject_ becomes next _ARGN_. If _reject_ is empty, then
    # set(ARGN) undefines _ARGN_, breaking the loop.
    set(ARGN ${reject})
  endwhile(DEFINED ARGN)

  set("${var}" ${answer} PARENT_SCOPE)
endfunction(strand_sort)
