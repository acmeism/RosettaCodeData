    % returns true if all elements of the string array a are equal, false otherwise %
    % As Algol W procedures cannot determine the bounds of an array, the bounds     %
    % must be specified in lo and hi                                                %
    logical procedure allStringsEqual ( string(256) array a ( * )
                                      ; integer     value lo, hi
                                      ) ;
    begin
        logical same;
        integer listPos;
        same    := true;
        listPos := lo + 1;
        while same and listPos <= hi do begin
            same    := a( lo ) = a( listPos );
            listPos := listPos + 1
        end;
        same
    end allStringsEqual ;

    % returns true if the elements of the string array a are in ascending order,    %
    % false otherwise                                                               %
    % As Algol W procedures cannot determine the bounds of an array, the bounds     %
    % must be specified in lo and hi                                                %
    logical procedure ascendingOrder  ( string(256) array a ( * )
                                      ; integer     value lo, hi
                                      ) ;
    begin
        logical ordered;
        integer listPos;
        ordered := true;
        listPos := lo + 1;
        while ordered and listPos <= hi do begin
            ordered := a( listPos - 1 ) < a( listPos );
            listPos := listPos + 1
        end;
        ordered
    end ascendingOrder ;
