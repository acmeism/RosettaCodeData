import: mapping

: A ( x )
   x sum
   x size dup ifZero: [ 2drop null ] else: [ >float / ]
;

: G( x )   #* x reduce  x size inv powf ;

: H( x )   x size x map( #inv ) sum / ;

: averages
| g |
   "Geometric mean  :" . 10 seq G dup .cr ->g
   "Arithmetic mean :" . 10 seq A dup . g >= ifTrue: [ " ==> A >= G" .cr ]
   "Harmonic mean   :" . 10 seq H dup . g <= ifTrue: [ " ==> G >= H" .cr ]
;
