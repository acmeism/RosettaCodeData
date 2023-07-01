report z_array_concatenation.

data(itab1) = value int4_table( ( 1 ) ( 2 ) ( 3 ) ).
data(itab2) = value int4_table( ( 4 ) ( 5 ) ( 6 ) ).

append lines of itab2 to itab1.

loop at itab1 assigning field-symbol(<line>).
    write <line>.
endloop.
