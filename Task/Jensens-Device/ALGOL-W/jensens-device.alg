begin
   integer i;
   real procedure sum  ( integer %name% i; integer value lo, hi; real procedure term );
      % i is passed by-name, term is passed as a procedure which makes it effectively passed by-name %
   begin
       real temp;
       temp := 0;
       i := lo;
       while i <= hi do begin      % The Algol W "for" loop (as in Algol 68) creates a distinct %
           temp := temp + term;    % variable which would not be shared with the passed "i" %
           i := i + 1              % Here the actual passed "i" is incremented. %
       end while_i_le_temp;
       temp
   end;
   % note the correspondence between the mathematical notation and the call to sum %
   write( sum( i, 1, 100, 1/i ) )
end.
