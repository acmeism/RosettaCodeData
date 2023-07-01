function! Factorial(n)
  if a:n < 2
    return 1
  else
    return a:n * Factorial(a:n-1)
  endif
endfunction
