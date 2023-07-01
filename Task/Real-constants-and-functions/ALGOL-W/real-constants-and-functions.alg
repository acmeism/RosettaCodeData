begin
    real t, u;
    t := 10;
    u := -2.3;
    i_w := 4; s_w := 0; r_format := "A"; r_d := 4; r_w := 9; % set output format %
    write( "         e: ", exp( 1 ) );         % e              %
    write( "        pi: ", pi );               % pi             %
    write( "    root t: ", sqrt( t ) );        % square root    %
    write( "     log t: ", log( t ) );         % log base 10    %
    write( "      ln t: ", ln( t ) );          % log base e     %
    write( "     exp u: ", exp( u ) );         % exponential    %
    write( "     abs u: ", abs u );            % absolute value %
    write( "  floor pi: ", entier( pi ) );     % floor          %
    write( "ceiling pi: ", - entier( - pi ) ); % ceiling        %
    % the raise-to-the-power operator is "**" - it only allows integers for the power %
    write( "  pi cubed: ", pi ** 3 ) % use exp( ln( x ) * y ) for general x^y %
end.
