   function x = hailstone(n)
      % iterative definition
      global VERBOSE;
      x = 1;
      while (1)
        if VERBOSE,
          printf('%i ',n);   % print element
        end;

        if n==1,
          return;
        elseif mod(n,2),
          n = 3*n+1;
        else
          n = n/2;
        end;
        x = x + 1;
      end;
   end;
