[][][][][][][][][]INT list1 = ((1), 2, ((3,4), 5), ((())), (((6))), 7, 8, () );
FILE   str file;
STRING str list;

# write the list to a string #
associate( str file, str list );
put( str file, ( list1 ) );
close( str file );

# count the number of elements #
INT element count := 0;
associate( str file, str list );
BOOL at end := FALSE;
on logical file end( str file, ( REF FILE f )BOOL: at end := TRUE );
WHILE INT value := 0;
      get( str file, value );
      NOT at end
DO
      element count +:= 1
OD;

# read the elements into a "flattened list" #
[ 1 : element count ]INT values;
rewind( str file );
at end := FALSE;
get( str file, ( values ) );
close( str file );

# show the elements #
FOR i FROM LWB values TO UPB values DO print( ( " ", whole( values[ i ], 0 ) ) ) OD;
print( ( newline ) )
