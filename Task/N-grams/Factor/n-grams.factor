USING: ascii grouping kernel math.statistics prettyprint ;

: n-grams ( str n -- assoc ) [ >upper ] dip clump histogram ;

"Live and let live" 2 n-grams .
