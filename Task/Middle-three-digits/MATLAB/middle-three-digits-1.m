function s=middle_three_digits(a)
% http://rosettacode.org/wiki/Middle_three_digits

s=num2str(abs(a));

if ~mod(length(s),2)
	s='*** error: number of digits must be odd ***';
	return;
end;
if length(s)<3,
	s='*** error: number of digits must not be smaller than 3 ***';
	return;
end;

s = s((length(s)+1)/2+[-1:1]);
