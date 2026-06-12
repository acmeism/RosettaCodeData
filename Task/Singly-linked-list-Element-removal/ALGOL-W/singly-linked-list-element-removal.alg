    % deletes the specified element from the list                             %
    %         if the element to remove is null or not in the list,            %
    %            nothing happens                                              %
    procedure Remove( reference(ListI) value result list
                    ; reference(ListI) value        element
                    ) ;
        if element not = null then begin
            % have an element to remove %
            if list = element then % remove the head % list := next(list)
            else begin
                % not removing the head element %
                Reference(ListI) listPos;
                listPos := list;
                while listPos not = null and next(listPos) not = element do listPos := next(listPos);
                if listPos not = null then % found the element % next(listPos) := next(next(listPos))
            end
        end Remove ;

    % declare a ListI list %
    reference(ListI) head;

    % ... add some elements to the list here ... %

    % remove the third element from a list %
    Remove( head, next(next(head)) );

    % remove the first element from a list %
    Remove( head, head );

