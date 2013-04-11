: comma-list ( n -- )
  dup 1+ 1 do
    i 1 .r
    dup i = if leave then   \ or DROP UNLOOP EXIT to exit loop and the function
    [char] , emit space
  loop drop ;
