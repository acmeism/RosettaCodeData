#!/usr/bin/awk -f
BEGIN {
  split("N NbE NNE NEbN NE NEbE ENE EbN E EbS ESE SEbE SE SEbS SSE SbE S SbW SSW SWbS SW SWbW WSW WbS W WbN WNW NWbW NW NWbN NNW NbW",A," ");
}

function ceil(x) {
	y = int(x)
	return y < x ? y + 1 : y
}

function compassbox(d) {
    return ceil( ( (d + 360 / 64) % 360) * 32 / 360);
}

{
    box = compassbox($1);
    printf "%6.2f : %2d\t%s\n",$1,box,A[box];
}
