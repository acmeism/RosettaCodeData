begin
    integer a, b;
    write( "Enter 2 integers> " );
    read( a, b );
    write( "a  +  b: ", a  +  b ); % addition         %
    write( "a  -  b: ", a  -  b ); % subtraction      %
    write( "a  *  b: ", a  *  b ); % multiplication   %
    write( "a  /  b: ", a div b ); % integer division %
    write( "a mod b: ", a rem b ); % modulo           %
    % the ** operator returns a real result even with integer operands  %
    % ( the right-hand operand must always be an integer, the left-hand %
    % operand can be integer, real or complex )                         %
    write( "a  ^  b: ", round( a ** b ) )
end.
