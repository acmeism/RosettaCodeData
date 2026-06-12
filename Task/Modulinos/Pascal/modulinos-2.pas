{$IFDEF scriptedmain}
program ScriptedMain;
{$ELSE}
unit ScriptedMain;
interface
function MeaningOfLife () : integer;
implementation
{$ENDIF}
	function MeaningOfLife () : integer;
	begin
		MeaningOfLife := 42
	end;
{$IFDEF scriptedmain}
begin
	write('Main: The meaning of life is: ');
	writeln(MeaningOfLife())
{$ENDIF}
end.
