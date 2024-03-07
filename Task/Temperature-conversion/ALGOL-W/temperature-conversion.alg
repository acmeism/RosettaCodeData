begin % convert Kelvin to Celcius, Farenheit and Rankine                      %
    real kelvin, rankine;
    write( "Kelvin: " );
    read( kelvin );
    rankine := ( 9 * kelvin ) / 5;
    r_format := "A"; r_w := 8; r_d := 2; s_w := 0;     % set output formating %
    write( kelvin, " Kelvin is:" );
    write( "    ", kelvin  - 273.15, " Celcius"   );
    write( "    ", rankine,          " Rankine"   );
    write( "    ", rankine - 459.67, " Farenheit" )
end.
