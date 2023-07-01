    % record type to hold an element of a doubly linked list of integers      %
    record DListIElement ( reference(DListIElement) prev
                         ; integer iValue
                         ; reference(DListIElement) next
                         );
    % additional record types would be required for other element types       %
