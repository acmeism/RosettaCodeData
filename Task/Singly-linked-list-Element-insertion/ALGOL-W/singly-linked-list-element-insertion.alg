    % inserts a new value after the specified element of a list               %
    procedure insert( reference(ListI) value list
                    ; integer          value newValue
                    ) ;
        next(list) := ListI( newValue, next(list) );

    % declare a variable to hold a list                                       %
    reference(ListI) head;

    % create a list of integers                                               %
    head := ListI( 1701, ListI( 9000, ListI( 42, ListI( 90210, null ) ) ) );

    % insert a new value into the list                                        %
    insert( next(head), 4077 );
