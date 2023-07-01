program variadicRoutinesDemo(input, output, stdErr);
{$mode objFPC}

// array of const is only supported in $mode objFPC or $mode Delphi
procedure writeLines(const arguments: array of const);
var
	argument: TVarRec;
begin
	// inside the body `array of const` is equivalent to `array of TVarRec`
	for argument in arguments do
	begin	
		with argument do
		begin
			case vType of
				vtInteger:
				begin
					writeLn(vInteger);
				end;
				vtBoolean:
				begin
					writeLn(vBoolean);
				end;
				vtChar:
				begin
					writeLn(vChar);
				end;
				vtAnsiString:
				begin
					writeLn(ansiString(vAnsiString));
				end;
				// and so on
			end;
		end;
	end;
end;

begin
	writeLines([42, 'is', true, #33]);
end.
