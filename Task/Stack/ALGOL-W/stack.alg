begin
    % define a Stack type that will hold StringStackElements     %
    % and the StringStackElement type                            %
    % we would need separate types for other element types       %
    record StringStack ( reference(StringStackElement) top );
    record StringStackElement ( string(8)                     element
                              ; reference(StringStackElement) next
                              );
    % adds e to the end of the StringStack s                     %
    procedure pushString ( reference(StringStack) value s
                         ; string(8)              value e
                         ) ;
        top(s) := StringStackElement( e, top(s) );
    % removes and returns the top element from the StringStack s %
    % asserts the Stack is not empty, which will stop the        %
    % program if it is                                           %
    string(8) procedure popString ( reference(StringStack) value s ) ;
    begin
        string(8) v;
        assert( not isEmptyStringStack( s ) );
        v     := element(top(s));
        top(s):= next(top(s));
        v
    end popStringStack ;
    % returns the top element of the StringStack s               %
    % asserts the Stack is not empty, which will stop the        %
    % program if it is                                           %
    string(8) procedure peekStringStack ( reference(StringStack) value s ) ;
    begin
        assert( not isEmptyStringStack( s ) );
        element(top(s))
    end popStringStack ;
    % returns true if the StringStack s is empty, false otherwise %
    logical procedure isEmptyStringStack ( reference(StringStack) value s ) ; top(s) = null;

    begin % test the StringStack operations %
        reference(StringStack) s;
        s := StringStack( null );
        pushString( s, "up"      );
        pushString( s, "down"    );
        pushString( s, "strange" );
        pushString( s, "charm"   );
        while not isEmptyStringStack( s ) do write( popString( s )
                                                  , if isEmptyStringStack( s ) then "(empty)"
                                                                               else peekStringStack( s )
                                                  )
    end
end.
