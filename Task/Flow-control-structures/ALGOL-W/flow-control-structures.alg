begin
    integer i;
    integer procedure getNumber ;
    begin
        integer n;
        write( "n> " );
        read( i );
        if i< 0 then goto negativeNumber;
        i
    end getNumber ;

    i := getNumber;
    write( "positive or zero" );
    go to endProgram;
negativeNumber:
    writeon( "negative" );
endProgram:
end.
