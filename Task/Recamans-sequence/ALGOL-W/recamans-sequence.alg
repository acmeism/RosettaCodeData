begin
    % calculate Recaman's sequence values                                              %

    % a hash table element - holds n, A(n) and a link to the next element with the     %
    %                        same hash value                                           %
    record AValue ( integer eN, eAn ; reference(AValue) eNext );

    % hash modulus                                                                     %
    integer HMOD;
    HMOD := 100000;

    begin
        reference(AValue) array hashTable ( 0 :: HMOD - 1 );
        integer array A ( 0 :: 14 );
        integer le1000Count, firstN, duplicateN, duplicateValue, n, An, An1, prevN, maxS;

        % adds an element to the hash table, returns true if an element with value An  %
        % was already present, false otherwise                                         %
        % if the value was already present, its eN value is returned in prevN          %
        logical procedure addAValue( integer value n, An ; integer result prevN ) ;
            begin
                integer hash;
                logical duplicate;
                reference(AValue) element;
                hash      := An rem HMOD;
                element   := hashTable( hash );
                duplicate := false;
                while element not = null and eAn(element) not = An do element := eNext(element);
                duplicate := element not = null;
                if not duplicate then hashTable( hash ) := AValue( n, An, hashTable( hash ) )
                                 else prevN := eN(element);
                duplicate
            end addAValue ;

        % initialise the hash table                                                    %
        for h := 0 until HMOD - 1 do hashTable( h ) := null;

        % calculate the values of the sequence until we have found values that         %
        % include all numbers in 1..1000                                               %
        % also store the first 15 values                                               %

        A( 0 ) := An1 := n := 0;
        le1000Count := 0;
        maxS := firstN := duplicateN := duplicateValue := -1;
        while le1000Count < 1000 do begin
            logical le0, duplicate;
            n  := n + 1;
            An := An1 - n;
            le0 := ( An <= 0 );
            if le0 then An := An1 + n;
            prevN := -1;
            duplicate := addAValue( n, An, prevN );
            if duplicate and not le0 then begin
                An := An1 + n;
                duplicate := addAValue( n, An, prevN )
            end if_duplicate_and_not_le0 ;
            if duplicate then begin
                % the value was already present %
                if firstN < 0 then begin   % have the first duplicate                  %
                    firstN         := n;
                    duplicateN     := prevN;
                    duplicateValue := An;
                end if_firstN_lt_0
                end
            else if An <= 1000 then le1000Count := le1000Count + 1;;
            if n < 15 then A( n ) := An;
            if An > maxS then maxS := An;
            An1 := An
        end while_le1000Count_lt_1000 ;

        % show the first 15 values of the sequence                                     %
        write( "A( 0 .. 14 ): " );
        for n := 0 until 14 do writeon( i_w := 1, A( n ) );
        % positions of the first duplicate                                             %
        write( i_w := 1
               , s_w := 0
               , "First duplicates: "
               , duplicateN
               , " "
               , firstN
               , " ("
               , duplicateValue
               , ")"
               );
        % number of elements required to include the first 1000 integers               %
        write( i_w := 1, "first element to include all 1..1000: ", n );
        write( i_w := 1, "max sequence value encountered: ", maxS )
    end

end.
