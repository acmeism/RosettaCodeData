# create a constant array of integers and set its values #
[]INT constant array = ( 1, 2, 3, 4 );
# create an array of integers that can be changed, note the size mst be specified #
# this array has the default lower bound of 1 #
[ 5 ]INT mutable array := ( 9, 8, 7, 6, 5 );
# modify the second element of the mutable array #
mutable array[ 2 ] := -1;
# array sizes are normally fixed when the array is created, however arrays can be #
# declared to be FLEXible, allowing their sizes to change by assigning a new array to them #
# The standard built-in STRING is notionally defined as FLEX[ 1 : 0 ]CHAR in the standard prelude #
# Create a string variable: #
STRING str := "abc";
# assign a longer value to it #
str := "bbc/itv";
# add a few characters to str, +=: adds the text to the beginning, +:= adds it to the end #
"[" +=: str; str +:= "]"; # str now contains "[bbc/itv]" #
# Arrays of any type can be FLEXible: #
# create an array of two integers #
FLEX[ 1 : 2 ]INT fa := ( 0, 0 );
# replace it with a new array of 5 elements #
fa := LOC[ -2 : 2 ]INT;
