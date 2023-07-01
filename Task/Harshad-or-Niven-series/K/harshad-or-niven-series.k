/ sum of digits of an integer
sumdig: {d::(); (0<){d::d,x!10; x%:10}/x; +/d}
/ Test if an integer is a Harshad number
isHarshad: {:[x!(sumdig x); 0; 1]} / Returns 1 if Harshad
/ Generate x Harshad numbers starting from y and display the list
hSeries: {harshad::();i:y;while[(x-#harshad)>0;:[isHarshad i; harshad::(harshad,i)]; i+:1];harshad}
