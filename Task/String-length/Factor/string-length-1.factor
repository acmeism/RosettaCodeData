: string-byte-length ( string -- n ) [ code-point-length ] map-sum ;
: string-byte-length-2 ( string -- n ) utf8 encode length ;
