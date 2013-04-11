: length ( list -- u )
  0 swap begin dup while 1 under+ @ repeat drop ;

: head ( list -- x )
  cell+ @ ;

: .numbers ( list -- )
  begin dup while dup head . @ repeat drop ;
