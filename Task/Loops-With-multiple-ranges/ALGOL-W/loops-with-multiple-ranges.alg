begin
    % translation of task PL/1 code, with minimal changes, semicolons required by      %
    % PL/1 but redundant in Algol W retained ( technically they introduce empty        %
    % statements after the "if" in the loop body and before the final "end" )          %
    % Note that in Algol W, the loop counter is a local variable to the loop and       %
    % the value of j is not available outside the loops                                %
    procedure loopBody ( integer value j );  %(below)  **  is exponentiation:  4**3=64 %
    begin sum := sum + abs(j);                                %add absolute value of J.%
          if abs(prod)<2**27 and j not = 0 then prod := prod*j; %PROD is small enough & J%
                                                              % ABS(n) = absolute value%
          end;                                                %not 0, then multiply it.%
                           %SUM and PROD are used for verification of J incrementation.%
      integer prod, sum, x, y, z, one, three, seven;
          prod :=  1;                        %start with a product of unity.           %
           sum :=  0;                        %  "     "  "   sum    " zero.            %
             x := +5;
             y := -5;
             z := -2;
           one :=  1;
         three :=  3;
         seven :=  7;
         for j :=   -three  step  three until round( 3**3 )        do loopBody( j );
         for j :=   -seven  step  x     until    +seven            do loopBody( j );
         for j :=      555              until    550 - y           do loopBody( j );
         for j :=       22  step -three until   -28                do loopBody( j );
         for j :=     1927              until  1939                do loopBody( j );
         for j :=        x  step  z     until     y                do loopBody( j );
         for j := round( 11**x )        until round( 11**x ) + one do loopBody( j );
         write(s_w := 0, " sum= ",  sum);                    %display strings to term.%
         write(s_w := 0, "prod= ", prod);                    %   "       "     "   "  %
end.
