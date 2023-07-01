function largestTruncatablePrimes(boundary)

    %Helper function for checking if a prime is left of right truncatable
    function [leftTruncatable,rightTruncatable] = isTruncatable(prime,checkLeftTruncatable,checkRightTruncatable)

        numDigits = ceil(log10(prime)); %calculate the number of digits in the prime less one
        powersOfTen = 10.^(0:numDigits); %cache the needed powers of ten

        leftTruncated = mod(prime,powersOfTen); %generate a list of numbers by repeatedly left truncating the prime

        %leading zeros will cause duplicate entries thus it is possible to
        %detect leading zeros if we rotate the list to the left or right
        %and check for any equivalences with the original list
        hasLeadingZeros = any( circshift(leftTruncated,[0 1]) == leftTruncated );

        if( hasLeadingZeros || not(checkLeftTruncatable) )
            leftTruncatable = false;
        else
            %check if all of the left truncated numbers are prime
            leftTruncatable = all(isprime(leftTruncated(2:end)));
        end

        if( checkRightTruncatable )
            rightTruncated = (prime - leftTruncated) ./ powersOfTen; %generate a list of right truncated numbers
            rightTruncatable = all(isprime(rightTruncated(1:end-1))); %check if all the right truncated numbers are prime
        else
            rightTruncatable = false;
        end

    end %isTruncatable()

    nums = primes(boundary); %generate all primes <= boundary

    %Flags that indicate if the largest left or right truncatable prime has not
    %been found
    leftTruncateNotFound = true;
    rightTruncateNotFound = true;

    for prime = nums(end:-1:1) %Search through primes in reverse order

        %Get if the prime is left and/or right truncatable, ignoring
        %checking for right truncatable if it has already been found
        [leftTruncatable,rightTruncatable] = isTruncatable(prime,leftTruncateNotFound,rightTruncateNotFound);

        if( leftTruncateNotFound && leftTruncatable ) %print out largest left truncatable prime
            display([num2str(prime) ' is the largest left truncatable prime <= ' num2str(boundary) '.']);
            leftTruncateNotFound = false;
        end

        if( rightTruncateNotFound && rightTruncatable ) %print out largest right truncatable prime
            display([num2str(prime) ' is the largest right truncatable prime <= ' num2str(boundary) '.']);
            rightTruncateNotFound = false;
        end

        %Terminate loop when the largest left and right truncatable primes have
        %been found
        if( not(leftTruncateNotFound || rightTruncateNotFound) )
            break;
        end
    end
end
