: kelvinToCelsius  273.15 - ;
: kelvinToFahrenheit   1.8 * 459.67 - ;
: kelvinToRankine  1.8 * ;

: testTemp(n)
   n kelvinToCelsius println
   n kelvinToFahrenheit println
   n kelvinToRankine println ;
