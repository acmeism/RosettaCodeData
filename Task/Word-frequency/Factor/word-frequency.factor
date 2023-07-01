USING: ascii io math.statistics prettyprint sequences
splitting ;
IN: rosetta-code.word-count

lines " " join " .,?!:;()\"-" split harvest [ >lower ] map
sorted-histogram <reversed> 10 head .
