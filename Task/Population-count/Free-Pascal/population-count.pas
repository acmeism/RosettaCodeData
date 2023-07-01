program populationCount(input, output, stdErr);
var
	// general advice: iterator variables are _signed_
	iterator: int64;
	// the variable we’d like to count the set bits in
	number: qWord;
	// how many evil numbers we’ve already found
	evilCount: int64;
	// odious numbers
	odiousNumber: array[1..30] of qWord;
	odiousIterator: int64;
begin
	// population count for powers of three
	for iterator := 0 to 29 do
	begin
		number := round(exp(ln(3) * iterator));
		write(popCnt(number):3);
	end;
	writeLn();
	
	// evil numbers
	// (while preserving calculated odious numbers for next sub-task)
	evilCount := 0;
	odiousIterator := low(odiousNumber);
	
	// for-loop: because we (pretend to) don’t know,
	// when and where we’ve found the first 30 numbers of each
	for iterator := 0 to high(iterator) do
	begin
		// implicit typecast: popCnt only accepts _un_-signed integers
		number := iterator;
		if odd(popCnt(number)) then
		begin
			if odiousIterator <= high(odiousNumber) then
			begin
				odiousNumber[odiousIterator] := number;
				inc(odiousIterator);
			end;
		end
		else
		begin
			if evilCount < 30 then
			begin
				write(number:20);
				inc(evilCount);
			end;
		end;
		
		if evilCount + odiousIterator > 60 then
		begin
			break;
		end;
	end;
	writeLn();
	
	// odious numbers
	for number in odiousNumber do
	begin
		write(number:20);
	end;
	writeLn();
end.
