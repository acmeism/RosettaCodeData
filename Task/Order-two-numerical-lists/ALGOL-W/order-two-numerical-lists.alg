begin % compare lists (rows) of integers %
    % returns TRUE if there is an element in a that is < the corresponding %
    % element in b and all previous elements are equal, FALSE otherwise    %
    % the bounds of a and b should aLb :: aUb and bLb :: bUb               %
    logical procedure iLT ( integer array a ( * )
                          ; integer value aLb, aUb
                          ; integer array b ( * )
                          ; integer value bLb, bUb
                          ) ;
    begin
        integer aPos, bPos;
        logical equal;
        aPos := aLb;
        bPos := bLb;
        equal := true;
        while aPos <= aUb and bPos <= bUb and equal do begin
            equal := a( aPos ) = b( bPos );
            if equal then begin
                aPos := aPOs + 1;
                bPos := bPos + 1
           end if_equal
        end while_more_elements_and_equal ;
        if not equal
        then % there is an element in a and b that is not equal %
             a( aPos ) < b( bPos )
        else % all elements are equal or one list is shorter %
             % a is < b if a has fewer elements %
             aPos > aUb and bPos <= bUb
    end iLT ;
    % tests a < b has the expected result %
    procedure test ( string(5) value aName
                   ; integer array a ( * )
                   ; integer value aLb, aUb
                   ; string(5) value bName
                   ; integer array b ( * )
                   ; integer value bLb, bUb
                   ; logical value expected
                   ) ;
    begin
        logical isLt;
        isLt := iLT( a, aLb, aUb, b, bLb, bUb );
        write( aName, if isLt then " <  " else " >= ", bName
             , if isLt = expected then "" else ", NOT as expected"
             )
    end test ;

    integer array list1, list3, list4 ( 1 :: 5 );
    integer array list2               ( 1 :: 6 );
    integer array list5               ( 1 :: 5 );
    integer array list6               ( 1 :: 4 );
    integer array list7               ( 1 :: 3 );
    integer array list8               ( 1 :: 1 );
    integer aPos;
    % test cases as in the BBC basic sample %
    aPos := 1; for i := 1, 2, 1, 5, 2    do begin list1( aPos ) := i; aPos := aPos + 1 end;
    aPos := 1; for i := 1, 2, 1, 5, 2, 2 do begin list2( aPos ) := i; aPos := aPos + 1 end;
    aPos := 1; for i := 1, 2, 3, 4, 5    do begin list3( aPos ) := i; aPos := aPos + 1 end;
    aPos := 1; for i := 1, 2, 3, 4, 5    do begin list4( aPos ) := i; aPos := aPos + 1 end;
    test( "list1", list1, 1, 5, "list2", list2, 1, 6, true  );
    test( "list2", list2, 1, 6, "list3", list3, 1, 5, true  );
    test( "list3", list3, 1, 5, "list4", list4, 1, 5, false );
    % additional test cases %
    aPos := 1; for i := 9, 0, 2, 1, 0    do begin list5( aPos ) := i; aPos := aPos + 1 end;
    aPos := 1; for i := 4, 0, 7, 7       do begin list6( aPos ) := i; aPos := aPos + 1 end;
    aPos := 1; for i := 4, 0, 7          do begin list7( aPos ) := i; aPos := aPos + 1 end;
    test( "list5", list5, 1, 5, "list6", list6, 1, 4, false );
    test( "list6", list6, 1, 4, "list7", list7, 1, 3, false );
    test( "list7", list7, 1, 3, "list8", list8, 1, 0, false );
    test( "list8", list8, 1, 0, "list7", list7, 1, 3, true  )
end.
