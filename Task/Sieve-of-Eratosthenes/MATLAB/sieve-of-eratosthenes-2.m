function P = sieveOfEratosthenes(x)
    ISP = [false true(1, x-1)]; % 1 is not prime, but we start off assuming all numbers between 2 and x are
    for n = 2:sqrt(x)
        if ISP(n)
            ISP(n*n:n:x) = false; % Multiples of n that are greater than n*n are not primes
        end
    end
    % The ISP vector that we have calculated is essentially the output of the ISPRIME function called on 1:x
    P = find(ISP); % Convert the ISPRIME output to the values of the primes by finding the locations
                   % of the TRUE values in S.
end
