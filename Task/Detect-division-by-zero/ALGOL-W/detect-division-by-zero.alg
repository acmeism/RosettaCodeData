begin
    % integer division procedure                                                 %
    %     sets c to a divided by b, returns true if the division was OK,         %
    %                                      false if there was division by zero   %
    logical procedure divideI ( integer value a, b; integer result c ) ;
    begin
        % set exception handling to allow integer division by zero to occur once %
        INTDIVZERO := EXCEPTION( false, 1, 0, false, "INTDIVZERO" );
        c := a div b;
        not XCPNOTED(INTDIVZERO)
    end divideI ;
    % real division procedure                                                    %
    %     sets c to a divided by b, returns true if the division was OK,         %
    %                                      false if there was division by zero   %
    logical procedure divideR ( long real value a, b; long real result c ) ;
    begin
        % set exception handling to allow realdivision by zero to occur once     %
        DIVZERO := EXCEPTION( false, 1, 0, false, "DIVZERO" );
        c := a / b;
        not XCPNOTED(DIVZERO)
    end divideR ;
    integer c;
    real    d;
    write( divideI( 4, 2, c ) ); % prints false as no exception                  %
    write( divideI( 5, 0, c ) ); % prints true as division by zero was detected  %
    write( divideR( 4, 2, d ) ); % prints false as no exception                  %
    write( divideR( 5, 0, d ) )  % prints true as division by zero was detected  %
end.
