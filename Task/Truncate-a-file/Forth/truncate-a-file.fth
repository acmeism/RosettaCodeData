: truncate-file ( fname fnamelen fsize -- )
  0 2swap r/w open-file throw
  dup >r resize-file throw
  r> close-file throw ;
