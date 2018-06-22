#!/bin/ksh
# Temperature conversion
typeset tt[1]=0.00 tt[2]=273.15 tt[3]=373.15
for i in {1..3}
do
	((t=tt[i]))
	echo $i
	echo "Kelvin:     $t K"
	echo "Celsius:    $((t-273.15)) C"
	echo "Fahrenheit: $((t*18/10-459.67)) F"
	echo "Rankine:    $((t*18/10)) R"
done
