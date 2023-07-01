function isPrime = primalityByTrialDivision(n)

    if n == 2
        isPrime = true;
        return
    elseif (mod(n,2) == 0) || (n <= 1)
        isPrime = false;
        return
    end

    %First n mod (3 to sqrt(n)) is taken. This will be a vector where the
    %first element is equal to n mod 3 and the last element is equal to n
    %mod sqrt(n). Then the all function is applied to that vector. If all
    %of the elements of this vector are non-zero (meaning n is prime) then
    %all() returns true. Otherwise, n is composite, so it returns false.
    %This return value is then assigned to the variable isPrime.
    isPrime = all(mod(n, (3:round(sqrt(n))) ));

end
