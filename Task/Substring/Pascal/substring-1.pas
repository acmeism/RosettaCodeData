program substring(output);
var
	sample: string(20) value 'Foobar';
	n, m: integer value 1;
begin
	{ starting from n characters in and of m length - - - - - - - - - - - - - - - }
	writeLn(subStr(sample, n, m));
	writeLn(subStr(sample, n):m);
	writeLn(sample[n .. n + m - 1]);
	
	{ starting from n characters in, up to the end of the string  - - - - - - - - }
	writeLn(subStr(sample, n));
	writeLn(sample[n .. length(sample)]);
	
	{ whole string minus the last character - - - - - - - - - - - - - - - - - - - }
	writeLn(subStr(sample, 1, length(sample) - 1));
	writeLn(sample[1 .. pred(length(sample))]);
	writeLn(sample:length(sample) - 1);
	{ To make this a permanent change you can use
	    writeStr(sample, sample:pred(length(sample)); }
	
	{ starting from a known character within the string and of m length - - - - - }
	writeLn(subStr(sample, index(sample, 'b'), m));
	writeLn(subStr(sample, index(sample, 'b')):m);
	writeLn(sample[index(sample, 'b') .. index(sample, 'b') + m - 1]);
	
	{ starting from a known substring within the string and of m length - - - - - }
	writeLn(subStr(sample, index(sample, 'bar'), m));
	writeLn(subStr(sample, index(sample, 'bar')):m);
	writeLn(sample[index(sample, 'bar') .. index(sample, 'bar') + m - 1]);
end.
