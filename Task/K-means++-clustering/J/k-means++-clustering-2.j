   randMatrix           =:  ?@$&0  NB.  Extra credit #1
   packPoints           =:  <"1@:|: NB.  Extra credit #2: Visualization code due to Max Harms http://j.mp/l8L45V
   plotClusters         =:  dyad define  NB.  as is the example image in this task
	require 'plot'
	pd 'reset;aspect 1;type dot;pensize 2'
	pd@:packPoints&> y
	pd 'type marker;markersize 1.5;color 0 0 0'
	pd@:packPoints x
	pd 'markersize 0.8;color 255 255 0'
	pd@:packPoints x
	pd 'show'
)

NB.  Extra credit #4:  Polar coordinates are not available in this version
NB.  but wouldn't be hard to provide with  &.cartToPole  .
