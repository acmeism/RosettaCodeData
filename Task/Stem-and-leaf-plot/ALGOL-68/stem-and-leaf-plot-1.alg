BEGIN # produce a stem and leaf plot of some numbers, leaf = last digit,     #
      #                                               stem = leading digits  #
    PR read "sort.incl.a68" PR       # include row (array) sorting utilities #
    []INT data = (  12, 127,  28,  42,  39, 113,  42,  18,  44, 118,  44
                 ,  37, 113, 124,  37,  48, 127,  36,  29,  31, 125, 139
                 , 131, 115, 105, 132, 104, 123,  35, 113, 122,  42, 117
                 , 119,  58, 109,  23, 105,  63,  27,  44, 105,  99,  41
                 , 128, 121, 116, 125,  32,  61,  37, 127,  29, 113, 121
                 ,  58, 114, 126,  53, 114,  96,  25, 109,   7,  31, 141
                 ,  46,  13,  27,  43, 117, 116,  27,   7,  68,  40,  31
                 , 115, 124,  42, 128,  52,  71, 118, 117,  38,  27, 106
                 ,  33, 117, 116, 111,  40, 119,  47, 105,  57, 122, 109
                 , 124, 115,  43, 120,  43,  27,  27,  18,  28,  48, 125
                 , 107, 114,  34, 133,  45, 120,  30, 127,  31, 116, 146
                 );
    # generates a stem-and-leaf plot of d, the stems and leaves are derived  #
    # from the elements by stem and leaf. the plot starts at first stem.     #
    # the data is assumed to be sorted into stem then leaf order             #
    PROC stem and leaf plot = ( []INT d, INT first stem, PROC(INT)INT stem, leaf )VOID:
         IF UPB d < LWB d THEN
             print( ( "No data", newline ) )
         ELSE
             # there is some data to plot                                    #
             INT  curr stem := stem( d[ LWB d ] );
             IF first stem < curr stem THEN
                 curr stem := first stem
             FI;
             curr stem -:= 1;
             BOOL first := TRUE;
             FOR i FROM LWB d TO UPB d DO
                 INT this stem = stem( d[ i ] );
                 IF first OR curr stem /= this stem THEN
                     curr stem +:= 1;
                     WHILE IF NOT first THEN
                               print( ( newline ) )
                           ELSE
                               first := FALSE
                           FI;
                           print( ( whole( curr stem, -4 ), "|" ) );
                           curr stem < this stem
                     DO
                           curr stem +:= 1
                     OD
                 FI;
                 print( ( " ", whole( leaf( d[ i ] ), 0 ) ) )
             OD
         FI # stem and leaf plot # ;

    # sort the data                                                          #
    [ LWB data : UPB data ]INT sorted data := data;
    # sort and plot the data: stem = element / 10, leaf = element MOD 10     #
    stem and leaf plot( QUICKSORT sorted data, 0, ( INT n )INT: n OVER 10, ( INT n )INT: n MOD 10 )

END
