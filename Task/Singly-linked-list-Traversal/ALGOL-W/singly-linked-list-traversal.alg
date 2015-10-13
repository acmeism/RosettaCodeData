begin
    % record type to hold a singly linked list of integers                    %
    record ListI ( integer iValue; reference(ListI) next );

    % inserts a new value after the specified element of a list               %
    procedure insert( reference(ListI) value list
                    ; integer          value newValue
                    ) ;
        next(list) := ListI( newValue, next(list) );

    % declare variables to hold the list                                      %
    reference(ListI) head, pos;

    % create a list of integers                                               %
    head := ListI( 1701, ListI( 9000, ListI( 42, ListI( 90210, null ) ) ) );

    % insert a new value into the list                                        %
    insert( next(head), 4077 );

    % traverse the list                                                       %
    pos := head;

    while pos not = null do begin
        write( iValue(pos) );
        pos := next(pos);
    end;

end.
