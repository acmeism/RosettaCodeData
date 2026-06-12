USING: io kernel strings ;
IN: input-output

GENERIC: do-stuff ( obj -- )
M: string do-stuff print ;

readln drop [ do-stuff ] each-line
