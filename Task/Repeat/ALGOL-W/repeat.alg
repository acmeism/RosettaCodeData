begin
    % executes the procedure routine the specified number of times            %
    procedure repeat ( integer value count; procedure routine ) ;
        for i := 1 until count do routine;
    begin
        integer x;
        % print "hello" three times                                           %
        repeat( 3, write( "hello" ) );
        % print the first 10 squares                                          %
        write();
        x := 1;
        repeat( 10
              , begin
                    writeon( i_w := s_w := 1, x * x );
                    x := x + 1
                end
              )
    end
end.
