begin
    integer a, b, c;

    a := 1; b := 2; c := 3;

    % algol W has the traditional Algol if-the-else statement                %
    % there is no "elseif" contraction                                       %
    if a = b
    then write( "a = b" )
    else if a = c
         then write( "a = c" )
         else write( "a is ", a );

    % if-then-else can also be used in an expression                         %
    write( if a < 4 then "lt 4" else "ge 4" );

    % algol W also has a "case" statement, an integer expression is used to  %
    % select the statement to execute. If the expression evaluates to 1,    %
    % the first statement is executed, if 2, the second is executed etc.     %
    % If the expression is less than 1 or greater than the number of         %
    % statements, a run time error occurs                                    %
    case a + b of
    begin write( "a + b is one"   )
        ; write( "a + b is two"   )
        ; write( "a + b is three" )
        ; write( "a + b is four"  )
    end;

    % there is also an expression form of the case:                          %
    write( case c - a of ( "one", "two", "three", "four" ) )

end.
