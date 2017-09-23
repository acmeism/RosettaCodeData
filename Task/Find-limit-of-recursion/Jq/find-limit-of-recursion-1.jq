def zero_arity:
  if (. % 1000000 == 0) then . else empty end, ((.+1)| zero_arity);

1|zero_arity
