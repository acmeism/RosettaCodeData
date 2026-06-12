USING: io kernel math.parser prettyprint sequences ;

25,000 <iota> [
    { 2 4 16 } [ >base ] with map [ dup reverse = ] all?
] filter [ pprint bl ] each nl
