USING: fry io kernel math prettyprint sequences ;
IN: rosetta-code.leonardo-numbers

: first25-leonardo ( vector add -- seq )
    23 swap '[ dup 2 tail* sum _ + over push ] times ;

: print-leo ( seq -- ) [ pprint bl ] each nl ;

"First 25 Leonardo numbers:" print
V{ 1 1 } 1 first25-leonardo print-leo

"First 25 Leonardo numbers with L(0)=0, L(1)=1, add=0:" print
V{ 0 1 } 0 first25-leonardo print-leo
