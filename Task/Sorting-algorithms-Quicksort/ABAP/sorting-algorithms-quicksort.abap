report z_quicksort.

data(numbers) = value int4_table( ( 4 ) ( 65 ) ( 2 ) ( -31 ) ( 0 ) ( 99 ) ( 2 ) ( 83 ) ( 782 ) ( 1 ) ).
perform quicksort changing numbers.

write `[`.
loop at numbers assigning field-symbol(<numbers>).
  write <numbers>.
endloop.
write `]`.

form quicksort changing numbers type int4_table.
  data(less) = value int4_table( ).
  data(equal) = value int4_table( ).
  data(greater) = value int4_table( ).

  if lines( numbers ) > 1.
    data(pivot) = numbers[ lines( numbers ) / 2 ].

    loop at numbers assigning field-symbol(<number>).
      if <number> < pivot.
        append <number> to less.
      elseif <number> = pivot.
        append <number> to equal.
      elseif <number> > pivot.
        append <number> to greater.
      endif.
    endloop.

    perform quicksort changing less.
    perform quicksort changing greater.

    clear numbers.
    append lines of less to numbers.
    append lines of equal to numbers.
    append lines of greater to numbers.
  endif.
endform.
