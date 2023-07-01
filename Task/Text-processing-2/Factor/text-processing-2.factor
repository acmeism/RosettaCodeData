USING: io io.encodings.ascii io.files kernel math math.parser
prettyprint sequences sequences.extras sets splitting ;

: check-format ( seq -- )
    [ " \t" split length 49 = ] all?
    "Format okay." "Format not okay." ? print ;

"readings.txt" ascii file-lines [ check-format ] keep
[ "Duplicates:" print [ "\t" split1 drop ] map duplicates . ]
[ [ " \t" split rest <odds> [ string>number 0 <= ] none? ] count ]
bi pprint " records were good." print
