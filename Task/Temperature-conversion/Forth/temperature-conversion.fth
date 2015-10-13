: k>°C  ( F: kelvin  -- celsius )     273.15e0 f- ;
: k>°R  ( F: kelvin  -- rankine )     1.8e0 f* ;
: °R>°F ( F: rankine -- fahrenheit )  459.67e0 f- ;
: k>°F  ( F: kelvin  -- fahrenheit )  k>°R °R>°F ;
: main
   argc 1 > if  1 arg >float
      fdup      f. ." K"  cr
      fdup k>°C f. ." °C" cr
      fdup k>°F f. ." °F" cr
      fdup k>°R f. ." °R" cr
   then ;

main bye
