/ happynum.k

/ sum of squares of digits of an integer
dgtsmsqr: {d::(); (0<){d::d,x!10; x%:10}/x; +/d*d}
/ Test if an integer is a Happy number
isHappy: {s::(); while[1<x;a:(dgtsmsqr x); :[(a _in s); :0; s::s,a]; x:a];:1} / Returns 1 if Happy
/ Generate first x Happy numbers and display the list
hnum: {[x]; h::();i:1;while[(#h)<x; :[(isHappy i); h::(h,i)]; i+:1]; `0: ,"List of ", ($x), " Happy Numbers"; h}
