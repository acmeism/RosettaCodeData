begin
    % record type to hold an element of a doubly linked list of integers      %
    record DListIElement ( reference(DListIElement) prev
                         ; integer iValue
                         ; reference(DListIElement) next
                         );
    % additional record types would be required for other element types       %
    % inserts a new element into the list, before e                           %
    reference(DListIElement) procedure insertIntoDListIBefore( reference(DListIElement) value e
                                                             ; integer                  value v
                                                             );
    begin
        reference(DListIElement) newElement;
        newElement := DListIElement( null, v, e );
        if e not = null then begin
            % the element we are inserting before is not null                 %
            reference(DListIElement) ePrev;
            ePrev            := prev(e);
            prev(newElement) := ePrev;
            prev(e)          := newElement;
            if ePrev not = null then next(ePrev) := newElement
        end if_e_ne_null ;
        newElement
    end insertIntoDListiAfter ;
    % removes an element e of a doubly linked list                            %
    procedure removeDListIElement( reference(DListIElement) value e );
        if e not = null then begin
            % have an element to remove                                       %
            reference(DListIElement) ePrev, eNext;
            ePrev            := prev(e);
            eNext            := next(e);
            if ePrev not = null then next(ePrev) := eNext;
            if eNext not = null then prev(eNext) := ePrev
        end removeDListIElement ;

    begin
        reference(DListIElement) head, e, toRemove, last;
        head     := null;
        head     := insertIntoDListIBefore( head,        1701 );
        head     := insertIntoDListIBefore( head,        9000 );
        e        := insertIntoDListIBefore( next(head), 90210 );
        toRemove := insertIntoDListIBefore( next(e),     4077 );
        e        := head;
        last     := null;
        write( "Before: Forward:" );
        while e not = null do begin
            write( i_w := 1, s_w := 0, " ", iValue(e) );
            last := e;
            e    := next(e)
        end while_e_ne_null ;
        write( "Before: Backward:" );
        e := last;
        while e not = null do begin
            write( i_w := 1, s_w := 0, " ", iValue(e) );
            last := e;
            e    := prev(e)
        end while_e_ne_null ;
        e        := head;
        last     := null;

        % remove an element                                                   %
        removeDListIElement( toRemove );

        write( "After: Forward:" );
        while e not = null do begin
            write( i_w := 1, s_w := 0, " ", iValue(e) );
            last := e;
            e    := next(e)
        end while_e_ne_null ;
        write( "After: Backward:" );
        e := last;
        while e not = null do begin
            write( i_w := 1, s_w := 0, " ", iValue(e) );
            last := e;
            e    := prev(e)
        end while_e_ne_null
    end
end.
