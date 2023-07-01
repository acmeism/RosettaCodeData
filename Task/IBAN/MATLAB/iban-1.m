function valid = validateIBAN(iban)
% Determine if International Bank Account Number is valid IAW ISO 13616
% iban - string containing account number
    if length(iban) < 5
        valid = false;
    else
        iban(iban == ' ') = '';                     % Remove spaces
        iban = lower([iban(5:end) iban(1:4)])+0;	% Rearrange and convert
        iban(iban > 96 & iban < 123) = iban(iban > 96 & iban < 123)-87; % Letters
        iban(iban > 47 & iban < 58) = iban(iban > 47 & iban < 58)-48;   % Numbers
        valid = piecewiseMod97(iban) == 1;
    end
end

function result = piecewiseMod97(x)
% Conduct a piecewise version of mod(x, 97) to support large integers
% x is a vector of integers
    x = sprintf('%d', x);	% Get to single-digits per index
    nDig = length(x);
    i1 = 1;
    i2 = min(9, nDig);
    prefix = '';
    while i1 <= nDig
        y = str2double([prefix x(i1:i2)]);
        result = mod(y, 97);
        prefix = sprintf('%d', result);
        i1 = i2+1;
        i2 = min(i1+8, nDig);
    end
end
