report z_mutual_recursion.

class hoffstadter_sequences definition.
  public section.
    class-methods:
      f
        importing
          n             type int4
        returning
          value(result) type int4,

      m
        importing
          n             type int4
        returning
          value(result) type int4.
endclass.


class hoffstadter_sequences implementation.
  method f.
    result = cond int4(
      when n eq 0
      then 1
      else n - m( f( n - 1 ) ) ).
  endmethod.


  method m.
    result = cond int4(
      when n eq 0
      then 0
      else n - f( m( n - 1 ) ) ).
  endmethod.
endclass.


start-of-selection.
  write: |{ reduce string(
    init results = |f(0 - 19): { hoffstadter_sequences=>f( 0 ) }|
    for i = 1 while i < 20
    next results = |{ results }, { hoffstadter_sequences=>f( i ) }| ) }|, /.

  write: |{ reduce string(
    init results = |m(0 - 19): { hoffstadter_sequences=>m( 0 ) }|
    for i = 1 while i < 20
    next results = |{ results }, { hoffstadter_sequences=>m( i ) }| ) }|, /.
