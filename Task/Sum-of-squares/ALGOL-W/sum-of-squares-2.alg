begin % sum the squares of the elements of a vector, using Jensen's Device %
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
   real array A ( 1 :: 5 );
   for i := 1 until 5 do A( i ) := i;
   r_format := "A"; r_w := 10; r_d := 1; % set fixed point output %
   write( sum( i, 1, 5, A( i ) * A( i ) ) );
end.
