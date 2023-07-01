USING: arrays kernel math math.constants math.functions math.vectors sequences ;

: haversin ( x -- y ) cos 1 swap - 2 / ;
: haversininv ( y -- x ) 2 * 1 swap - acos ;
: haversineDist ( as bs -- d )
[ [ 180 / pi * ] map ] bi@
  [ [ swap - haversin ] 2map ]
  [ [ first cos ] bi@ * 1 swap 2array ]
  2bi
v.
haversininv R_earth * ;
