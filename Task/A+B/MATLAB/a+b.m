function sumOfInputs = APlusB()
    inputStream = input('Enter two numbers, separated by a space: ', 's');
    numbers = str2num(inputStream);                         %#ok<ST2NM>
    if any(numbers < -1000 | numbers > 1000)
        warning('APlusB:OutOfRange', 'Some numbers are outside the range');
    end
    sumOfInputs = sum(numbers);
end
