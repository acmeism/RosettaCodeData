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
