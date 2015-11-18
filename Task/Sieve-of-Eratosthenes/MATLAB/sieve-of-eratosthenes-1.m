function P = erato(x)        % Sieve of Eratosthenes: returns all primes between 2 and x

    P = [0 2:x] ;            % Create vector with all ints between 2 and x where
                             %   position 1 is hard-coded as 0 since 1 is not a prime.

    for (n=2:sqrt(x))        % All primes factors lie between 2 and sqrt(x).
       if P(n)               % If the current value is not 0 (i.e. a prime),
          P((2*n):n:x) = 0 ; % then replace all further multiples of it with 0.
       end
    end                      % At this point P is a vector with only primes and zeroes.

    P = P(P ~= 0) ;          % Remove all zeroes from P, leaving only the primes.

return
