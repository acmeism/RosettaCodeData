#! /bin/bash
# Based on https://en.wikipedia.org/wiki/Midpoint_circle_algorithm

function putpixel {
    echo -en "\e[$2;$1H#"
}

function drawcircle {
    x0=$1
    y0=$2
    radius=$3

    for y in $( seq $((y0-radius)) $((y0+radius)) )
    do
        echo -en "\e[${y}H"
    	for x in $( seq $((x0+radius)) )
	do
		echo -n "-"
	done
    done

    x=$((radius-1))
    y=0
    dx=1
    dy=1
    err=$((dx-(radius<<1)))

    while [ $x -ge $y ]
    do
        putpixel $(( x0 + x )) $(( y0 + y ))
        putpixel $(( x0 + y )) $(( y0 + x ))
        putpixel $(( x0 - y )) $(( y0 + x ))
        putpixel $(( x0 - x )) $(( y0 + y ))
        putpixel $(( x0 - x )) $(( y0 - y ))
        putpixel $(( x0 - y )) $(( y0 - x ))
        putpixel $(( x0 + y )) $(( y0 - x ))
        putpixel $(( x0 + x )) $(( y0 - y ))

        if [ $err -le 0 ]
        then
	    ((++y))
            ((err+=dy))
            ((dy+=2))
        fi
        if [ $err -gt 0 ]
	then
            ((--x))
            ((dx+=2))
            ((err+=dx-(radius<<1)))
        fi
    done
}

clear
drawcircle 13 13 11
echo -en "\e[H"
