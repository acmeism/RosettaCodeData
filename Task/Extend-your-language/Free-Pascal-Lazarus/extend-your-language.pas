program fourWay(input, output, stdErr);
var
	tuple: record
			A: boolean;
			B: char;
		end;
begin
	tuple.A := true;
	tuple.B := 'Z';
	case tuple of
		(A: false; B: 'R'):
		begin
			writeLn('R is not good');
		end;
		(A: true; B: 'Z'):
		begin
			writeLn('Z is great');
		end;
		else
		begin
			writeLn('No');
		end;
	end;
end.
