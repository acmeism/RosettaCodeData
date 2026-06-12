program Parse_command_line_argument;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

var
  sfile, sLength: string;
  verbose: boolean;

begin
  if (ParamCount = 0) or (FindCmdLineSwitch('h', true)) then
  begin
    Writeln('Usage: -file {filename} -l {length} {-v}'#10);
    Writeln('* filename:     Name of file to process. Default "file.dat";');
    Writeln('* length:       Max number of bytes to read (not optional);');
    Writeln('* -v (verbose): show information on terminal. Default "false"');
  end
  else
  begin
    Assert(FindCmdLineSwitch('l', sLength), 'Length is not optional');

    if not FindCmdLineSwitch('file', sfile) then
      sfile := 'file.dat';

    verbose := FindCmdLineSwitch('v', True);

    Writeln('Variables states:'#10);
    Writeln('File: ', sfile);
    Writeln('Verbose: ', verbose);
    Writeln('Length: ', sLength);
  end;

  Readln;
end.
