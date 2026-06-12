USING: kernel math.functions math.ranges prettyprint sequences
sets sorting ;

2 5 [a,b] dup [ ^ ] cartesian-map concat members natural-sort .
