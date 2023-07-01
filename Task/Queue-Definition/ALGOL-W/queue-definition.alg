begin
    % define a Queue type that will hold StringQueueElements %
    record StringQueue ( reference(StringQueueElement) front, back );
    % define the StringQueueElement type %
    record StringQueueElement ( string(8)                     element
                              ; reference(StringQueueElement) next
                              );
    % we would need separate types for other element types   %
    % adds s to the end of the StringQueue q                 %
    procedure pushString ( reference(StringQueue) value q
                         ; string(8)              value e
                         ) ;
    begin
        reference(StringQueueElement) newElement;
        newElement := StringQueueElement( e, null );
        if front(q) = null then begin
            % adding to an empty queue %
            front(q) := newElement;
            back(q)  := newElement
            end
        else begin
            % the queue is not empty %
            next(back(q)) := newElement;
            back(q)       := newElement
        end
    end pushString ;
    % removes an element from the front of the StringQueue q %
    % asserts the queue is not empty, which will stop the    %
    % program if it is                                       %
    string(8) procedure popString ( reference(StringQueue) value q ) ;
    begin
        string(8) v;
        assert( not isEmptyStringQueue( q ) );
        v        := element(front(q));
        front(q) := next(front(q));
        if front(q) = null then % just popped the last element % back(q) := null;
        v
    end popStringQueue ;
    % returns true if the StringQueue q is empty, false otherwise %
    logical procedure isEmptyStringQueue ( reference(StringQueue) value q ) ; front(q) = null;

    begin % test the StringQueue operations %
        reference(StringQueue) q;
        q := StringQueue( null, null );
        pushString( q, "fred"   );
        pushString( q, "whilma" );
        pushString( q, "betty"  );
        pushString( q, "barney" );
        while not isEmptyStringQueue( q ) do write( popString( q ) )
    end
end.
