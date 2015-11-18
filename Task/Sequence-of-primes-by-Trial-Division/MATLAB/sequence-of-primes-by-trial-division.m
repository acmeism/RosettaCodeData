function primeList = sieveOfEratosthenes(lastNumber)

    list = (2:lastNumber); %Construct list of numbers
    primeList = []; %Preallocate prime list

    while( list(1)^2 <lastNumber )

        primeList = [primeList list(1)]; %add prime to the prime list
        list( mod(list,list(1))==0 ) = []; %filter out all multiples of the current prime

    end

    primeList = [primeList list]; %The rest of the numbers in the list are primes

end
