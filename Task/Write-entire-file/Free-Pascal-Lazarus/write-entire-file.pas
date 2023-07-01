program overwriteFile(input, output, stdErr);
{$mode objFPC} // for exception treatment
uses
	sysUtils; // for applicationName, getTempDir, getTempFileName
	// also: importing sysUtils converts all run-time errors to exceptions
resourcestring
	hooray = 'Hello world!';
var
	FD: text;
begin
	// on a Debian GNU/Linux distribution,
	// this will write to /tmp/overwriteFile00000.tmp (or alike)
	assign(FD, getTempFileName(getTempDir(false), applicationName()));
	try
		rewrite(FD); // could fail, if user has no permission to write
		writeLn(FD, hooray);
	finally
		close(FD);
	end;
end.
