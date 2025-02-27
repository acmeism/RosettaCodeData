: triangle-allocate ( u -- addr )
  dup 1+ * 2/ cells dup
  allocate abort" out of memory"
  tuck swap erase ;

: triangle-deallocate ( addr -- )
  free abort" memory deallocation error" ;

: triangle-row-address ( addr u -- addr )
  dup 1+ * 2/ cells + ;

: bell-triangle-row ( addr u -- )
  tuck 1- triangle-row-address
  2dup swap cells +
  dup 1 cells - @ over !
  rot 0 ?do
    dup @ >r over @ r> + >r
    cell+ r> over !
    swap cell+ swap
  loop 2drop ;

: bell-triangle ( u -- addr )
  dup triangle-allocate
  dup 1 swap !
  swap 1 ?do
    dup i bell-triangle-row
  loop ;

: print-bell-numbers ( addr u -- )
  0 ?do
    dup i triangle-row-address @ . cr
  loop drop ;

: print-bell-row ( addr u -- )
  tuck triangle-row-address swap
  1+ 0 ?do
    dup @ . cell+
  loop drop cr ;

: main ( -- )
  15 bell-triangle
  ." First 15 Bell numbers:" cr
  dup 15 print-bell-numbers cr
  ." First 10 rows of the Bell triangle:" cr
  10 0 do
    dup i print-bell-row
  loop
  triangle-deallocate ;

main
bye
