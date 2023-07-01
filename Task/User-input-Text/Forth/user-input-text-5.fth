: input#
  begin
    refill drop bl parse-word          ( a n)
    number error?                      ( n f)
  while                                ( n)
    drop                               ( --)
  repeat                               ( n)
;
