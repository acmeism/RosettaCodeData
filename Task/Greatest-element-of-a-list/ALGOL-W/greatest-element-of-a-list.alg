begin
    % simple list type                                                       %
    record IntList( integer val; reference(IntList) next );

    % find the maximum element of an IntList, returns 0 for an empty list    %
    integer procedure maxElement( reference(IntList) value list ) ;
        begin
            integer maxValue;
            reference(IntList) listPos;
            maxValue := 0;
            listPos  := list;
            if listPos not = null then begin
                % non-empty list                                             %
                maxValue := val(listPos);
                listPos  := next(listPos);
                while listPos not = null do begin
                    if val(listPos) > maxValue then maxValue := val(listPos);
                    listPos := next(listPos)
                end while_listPos_ne_null ;
            end if_listPos_ne_null ;
            maxValue
        end maxElement ;

    % test the maxElement procedure                                          %
    write( maxElement( IntList( -767, IntList( 2397, IntList( 204, null ) ) ) ) )

end.
