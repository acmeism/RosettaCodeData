{$ifDef FPC}{$mode ISO}{$endIf}
program overwriteFile(FD);
begin
	writeLn(FD, 'Whasup?');
	close(FD);
end.
