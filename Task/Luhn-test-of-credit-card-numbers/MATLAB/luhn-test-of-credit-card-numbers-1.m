function passes = luhnTest(creditCardNum)

    %flip the order of the digits
    creditCardNum = fliplr( num2str(creditCardNum) )';

    %sum the odd indexed digits
    s1 = sum( str2num( creditCardNum(1:2:length(creditCardNum)) ) );

    %multiply the even indexed digits by 2
    s2 = 2 * str2num(creditCardNum(2:2:length(creditCardNum)));

    %convert s2 into a cell array of strings, where each even indexed digit
    %multiplied by 2 takes one cell in the cell array.
    s2 = cellstr(num2str(s2));

    %go through each cell in the cell array and make the strings a column
    %array of chars
    s2 = cellfun(@transpose,s2,'UniformOutput',false);

    %convert each array of chars into an array of numbers
    s2 = cellfun(@str2num ,s2,'UniformOutput',false);

    %Sum the partial sums of the even indexed digits to form s2
    s2 = sum( cellfun(@sum, s2));

    %Convert the sum of s1 and s2 into a column vector with each digit of
    %the the sum being an element of the vector
    passes = str2num(num2str(s1+s2).');

    %Find the smallest digit in the checksum, zero will only appear in the
    %last digit of the number if zero is a digit of the checksum. Then
    %convert the minimum digit to a boolean. Only zero will convert to a
    %boolean false, any number larger than zero will convert to true.
    %Therefore, because we want to determine if a credit card number passes
    %the Luhn Test, we have to not the result of the conversion to boolean.
    passes =  ~logical(min(passes));

end
