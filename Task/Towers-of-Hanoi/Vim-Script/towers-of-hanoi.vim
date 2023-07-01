function TowersOfHanoi(n, from, to, via)
  if (a:n > 1)
    call TowersOfHanoi(a:n-1, a:from, a:via, a:to)
  endif
  echom("Move a disc from " . a:from . " to " . a:to)
  if (a:n > 1)
    call TowersOfHanoi(a:n-1, a:via, a:to, a:from)
  endif
endfunction

call TowersOfHanoi(4, 1, 3, 2)
