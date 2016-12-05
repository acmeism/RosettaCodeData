# use the associative array in the Associate array/iteration task    #
# this example uses strings - for other types, the associative       #
# array modes AAELEMENT and AAKEY should be modified as required     #
PR read "aArray.a68" PR

# returns the unique elements of list                                #
PROC remove duplicates = ( []STRING list )[]STRING:
     BEGIN
        REF AARRAY elements := INIT LOC AARRAY;
        INT        count    := 0;
        FOR pos FROM LWB list TO UPB list DO
            IF NOT ( elements CONTAINSKEY list[ pos ] ) THEN
                # first occurance of this element                    #
                elements // list[ pos ] := "";
                count +:= 1
            FI
        OD;
        # construct an array of the unique elements from the         #
        # associative array - the new list will not necessarily be   #
        # in the original order                                      #
        [ count ]STRING result;
        REF AAELEMENT e := FIRST elements;
        FOR pos WHILE e ISNT nil element DO
            result[ pos ] := key OF e;
            e := NEXT elements
        OD;
        result
     END; # remove duplicates #

# test the duplicate removal                                         #
print( ( remove duplicates( ( "A", "B", "D", "A", "C", "F", "F", "A" ) ), newline ) )
