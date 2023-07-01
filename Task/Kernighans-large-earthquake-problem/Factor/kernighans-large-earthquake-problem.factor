USING: io math math.parser prettyprint sequences splitting ;
IN: rosetta-code.kernighan

lines [ "\s" split last string>number 6 > ] filter .
