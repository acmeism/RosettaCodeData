#!/bin/bash
# Temperature conversion
tt[1]=0.00; tt[2]=273.15; tt[3]=373.15
for i in {1..3}
do
	t=${tt[$i]}
	echo $i
	echo "Kelvin:     $t K"
	echo "Celsius:    $(bc<<<"scale=2;$t-273.15") C"
	echo "Fahrenheit: $(bc<<<"scale=2;$t*18/10-459.67") F"
	echo "Rankine:    $(bc<<<"scale=2;$t*18/10") R"
done
