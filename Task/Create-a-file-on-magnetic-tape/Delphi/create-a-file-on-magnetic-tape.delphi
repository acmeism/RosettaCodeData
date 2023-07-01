program Create_a_file_on_magnetic_tape;

{$APPTYPE CONSOLE}

const
{$IFDEF WIN32}
  FileName = 'tape.file';
{$ELSE}
  FileName = '/dev/tape';
{$ENDIF}

var
  f: TextFile;

begin
  Assign(f, FileName);
  Rewrite(f);
  Writeln(f, 'Hello World');
  close(f);
end.
