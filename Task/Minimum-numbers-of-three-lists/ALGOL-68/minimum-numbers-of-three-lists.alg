BEGIN # construct a list of the minimum values of some other lists #
    # lists are represented by arrays in this sample #
    PR read "rows.incl.a68" PR # row-related utilities #
    # returns a list composed of the minimum values of the lists in lists #
    #         the lists must all have te same bounds #
    PROC min = ( []REF[]INT lists )[]INT:
         IF   LWB lists > UPB lists
         THEN # no lists #
              []INT()
         ELIF INT l length = ( UPB lists[ LWB lists ] + 1 ) - LWB lists[ LWB lists ];
              l length < 1
         THEN # the lists are empty #
              []INT()
         ELSE # have some elements in the lists #
              [ 1 : l length ]INT result;
              INT r pos  := 0;
              FOR i FROM LWB lists[ LWB lists ] TO UPB lists[ LWB lists ] DO
                  INT l min := lists[ LWB lists ][ i ];
                  FOR j FROM LWB lists + 1 TO UPB lists DO
                      IF l min > lists[ j ][ i ] THEN l min := lists[ j ][ i ] FI
                  OD;
                  result[ r pos +:= 1 ] := l min
              OD;
              result
         FI # min # ;

    # construct the lists of numbers required by the task #
    REF[]INT numbers1 = HEAP[ 1 : 5 ]INT := (  5, 45, 23, 21, 67 );
    REF[]INT numbers2 = HEAP[ 1 : 5 ]INT := ( 43, 22, 78, 46, 38 );
    REF[]INT numbers3 = HEAP[ 1 : 5 ]INT := (  9, 98, 12, 98, 53 );
    # display the minimum values for each element in the lists #
    SHOW min( ( numbers1, numbers2, numbers3 ) )
END
