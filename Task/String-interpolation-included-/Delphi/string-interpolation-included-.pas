program Project1;

uses
  System.SysUtils;

var
  Template : string;
  Marker : string;
  Description : string;
  Value : integer;
  Output : string;

begin
  // StringReplace can be used if you are definitely using strings
  // http://docwiki.embarcadero.com/Libraries/XE7/en/System.SysUtils.StringReplace
  Template := 'Mary had a X lamb.';
  Marker := 'X';
  Description := 'little';
  Output := StringReplace(Template, Marker, Description, [rfReplaceAll, rfIgnoreCase]);
  writeln(Output);

  // You could also use format to do the same thing.
  // http://docwiki.embarcadero.com/Libraries/XE7/en/System.SysUtils.Format
  Template := 'Mary had a %s lamb.';
  Description := 'little';
  Output := format(Template,[Description]);
  writeln(Output);

  // Unlike StringReplace, format is not restricted to strings.
  Template := 'Mary had a %s lamb. It was worth $%d.';
  Description := 'little';
  Value := 20;
  Output := format(Template,[Description, Value]);
  writeln(Output);

end.
