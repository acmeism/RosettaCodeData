USING: kernel math math.order math.vectors sequences ;
: fill ( seq len -- newseq ) [ dup length ] dip swap - 0 <repetition> append ;

: bead ( seq -- newseq )
dup 0 [ max ] reduce
[ swap 1 <repetition> swap fill ] curry map
[ ] [ v+ ] map-reduce ;

: beadsort ( seq -- newseq ) bead bead ;
