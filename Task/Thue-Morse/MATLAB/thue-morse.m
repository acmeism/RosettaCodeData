tmSequence = thue_morse_digits(20);
disp(tmSequence);

function tmSequence = thue_morse_digits(n)
    tmSequence = zeros(1, n);
    for i = 0:(n-1)
        binStr = dec2bin(i);
        numOnes = sum(binStr == '1');
        tmSequence(i+1) = mod(numOnes, 2);
    end
end
