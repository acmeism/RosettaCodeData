clear all;close all;clc;

% Find the first 20 Brazilian numbers in the range 7 to 100.
brazilian_numbers = [];
for num = 7:100
    if brazilianQ(num)
        brazilian_numbers = [brazilian_numbers, num];
        if length(brazilian_numbers) == 20
            break;
        end
    end
end
% For Brazilian numbers
fprintf('% 8d', brazilian_numbers);
fprintf("\n");


% Find the first 20 odd Brazilian numbers in the range 7 to 100.
odd_brazilian_numbers = [];
for num = 7:100
    if brazilianQ(num) && mod(num, 2) ~= 0
        odd_brazilian_numbers = [odd_brazilian_numbers, num];
        if length(odd_brazilian_numbers) == 20
            break;
        end
    end
end
% For odd Brazilian numbers
fprintf('% 8d', odd_brazilian_numbers);
fprintf("\n");


% Find the first 20 Brazilian prime numbers in the range 7 to 10000.
brazilian_prime_numbers = [];
for num = 7:10000
    if brazilianQ(num) && isprime(num)
        brazilian_prime_numbers = [brazilian_prime_numbers, num];
        if length(brazilian_prime_numbers) == 20
            break;
        end
    end
end
% For Brazilian prime numbers
fprintf('% 8d', brazilian_prime_numbers);
fprintf("\n");



function isBrazilian = brazilianQ(n)
    % Function to check if a number is a Brazilian number.
    if n <= 6
        error('Input must be greater than 6.');
    end
    isBrazilian = false;
    for b = 2:(n-2)
        base_b_digits = custom_dec2base(n, b) - '0'; % Convert number to base b and then to digits
        if all(base_b_digits == base_b_digits(1))
            isBrazilian = true;
            break;
        end
    end
end

function digits = custom_dec2base(num, base)
    % Custom function to convert number to any base representation
    if base < 2 || base > num
        error('Base must be at least 2 and less than the number itself.');
    end
    digits = [];
    while num > 0
        remainder = mod(num, base);
        digits = [remainder, digits];
        num = floor(num / base);
    end
end
