package require units

set russian_units {
      arshin  1.40607
  centimeter  100
       diuym  39.3701
         fut  3.28084
   kilometer  0.001
      liniya  393.701
       meter  1
       milia  0.000133912
        piad  5.6243
      sazhen  0.468691
      tochka  3937.01
     vershok  22.4972
      versta  0.000937383
}

proc add_russian_units {} {
    foreach {name factor} $::russian_units {
        if {$name eq "meter"} continue
        set factor [expr {1/$factor}]
        units::new $name "$factor meters"   ;# teach units about the new unit
    }
}

proc demo {} {  ;# show some examples
    foreach base {"1 meter" "1 milia"} {
        puts "$base to:"
        foreach {unit _} $::russian_units {
            puts [format " %-12s: %s" $unit [units::convert $base $unit]]
        }
        puts ""
    }
}

add_russian_units
demo
