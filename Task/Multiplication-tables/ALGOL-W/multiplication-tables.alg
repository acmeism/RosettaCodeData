begin
    % print a school style multiplication table                              %
    i_w := 3; s_w := 0; % set output formating                               %
    write( "    " );
    for i := 1 until 12 do writeon( " ", i );
    write( "   +" );
    for i := 1 until 12 do writeon( "----" );
    for i := 1 until 12 do begin
        write( i, "|" );
        for j := 1 until i - 1 do writeon( "    " );
        for j := i until 12    do writeon( " ", i * j );
    end;

end.
