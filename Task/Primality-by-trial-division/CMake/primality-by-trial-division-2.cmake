# Quick example.
foreach(i -5 1 2 3 37 39)
  primep(b ${i})
  if(b)
    message(STATUS "${i} is prime.")
  else()
    message(STATUS "${i} is _not_ prime.")
  endif(b)
endforeach(i)
