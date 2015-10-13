    % record type to hold a singly linked list of integers                    %
    record ListI ( integer iValue; reference(ListI) next );

    % declare a variable to hold a list                                       %
    reference(ListI) head;

    % create a list of integers                                               %
    head := ListI( 1701, ListI( 9000, ListI( 42, ListI( 90210, null ) ) ) );
