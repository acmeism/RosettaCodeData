procedure booleanOperations( logical value a, b ) ;
    begin

        % algol W has the usual "and", "or" and "not" operators         %
        write( a,      " and ", b, ": ", a and   b );
        write( a,      "  or ", b, ": ", a  or   b );
        write( "         not ", a, ": ",   not   a );

        % logical values can be compared with the = and not = operators %
        %     a not = b can be used for a xor b                         %
        write( a,      " xor ", b, ": ", a not = b );
        write( a,      " equ ", b, ": ", a     = b );

    end booleanOperations ;
