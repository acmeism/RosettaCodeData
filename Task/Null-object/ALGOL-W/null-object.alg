begin
    % declare a record type - will be accessed via references                %
    record R( integer f1, f2, f3 );
    % declare a reference to a R instance                                    %
    reference(R) refR;
    % assign null to the reference                                           %
    refR := null;
    % test for a null reference - will write "refR is null"                  %
    if refR = null then write( "refR is null" ) else write( "not null" );
end.
