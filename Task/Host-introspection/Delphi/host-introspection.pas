program HostIntrospection ;

{$APPTYPE CONSOLE}

uses SysUtils;

begin
  Writeln('word size: ', SizeOf(Integer));
  Writeln('endianness: little endian'); // Windows is always little endian
end.
