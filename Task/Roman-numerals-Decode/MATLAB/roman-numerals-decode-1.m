function x = rom2dec(s)
% ROM2DEC converts Roman numbers to decimal

% store Roman digits values: I=1, V=5, X=10, L=50, C=100, D=500, M=1000
digitsValues = [0 0 100 500 0 0 0 0 1 0 0 50 1000 0 0 0 0 0 0 0 0 5 0 10 0 0];
% convert Roman number to array of values
values = digitsValues(s-'A'+1);
% change sign if next value is bigger
x = sum(values .* [sign(diff(-values)+eps),1]);

end
