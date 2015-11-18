function passed = luhn(num)
if nargin == 0 % evaluate test cases
  testnum = [49927398716 49927398717 1234567812345678 1234567812345670];
  for num = testnum
    disp([int2str(num) ': ' int2str(luhn(num))])
  end
  return
end
% luhn function starts here
d = int2str(num) - '0';	% convert number into vector of digits
m = [2:2:8,1:2:9];	% rule 3: maps 1:9 to [2 4 6 8 1 3 5 7 9]
passed = ~mod(sum(d(end:-2:1)) + sum(m(d(end-1:-2:1))), 10);
end
