report z_array_length.

data(internal_table) = value stringtab( ( `apple` ) ( `orange` ) ).

write: internal_table[ 1 ] , internal_table[ 2 ] , lines( internal_table ).
