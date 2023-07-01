report z_catalan_numbers.

class catalan_numbers definition.
  public section.
    class-methods:
      get_nth_number
        importing
          i_n                     type int4
        returning
          value(r_catalan_number) type int4.
endclass.

class catalan_numbers implementation.
  method get_nth_number.
    r_catalan_number = cond int4(
      when i_n eq 0
      then 1
      else reduce int4(
        init
          result = 1
          index = 1
        for position = 1 while position <= i_n
        next
          result = result * 2 * ( 2 * index - 1 ) div ( index + 1 )
          index = index + 1 ) ).
  endmethod.
endclass.

start-of-selection.
  do 15 times.
    write / |C({ sy-index - 1 }) = { catalan_numbers=>get_nth_number( sy-index - 1 ) }|.
  enddo.
