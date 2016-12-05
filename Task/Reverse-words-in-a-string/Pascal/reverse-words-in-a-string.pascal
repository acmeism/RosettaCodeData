program Reverse_words(Output);
{$H+}

const
  nl = chr(10); // Linefeed
  sp = chr(32); // Space
  TXT =
  '---------- Ice and Fire -----------'+nl+
  nl+
  'fire, in end will world the say Some'+nl+
  'ice. in say Some'+nl+
  'desire of tasted I''ve what From'+nl+
  'fire. favor who those with hold I'+nl+
  nl+
  '... elided paragraph last ...'+nl+
  nl+
  'Frost Robert -----------------------'+nl;

var
  I : integer;
  ew, lw : ansistring;
  c : char;

function addW : ansistring;
var r : ansistring = '';
begin
  r := ew + sp + lw;
  ew := '';
  addW := r
end;

begin
  ew := '';
  lw := '';

  for I := 1 to strlen(TXT) do
  begin
    c := TXT[I];
    case c of
      sp : lw := addW;
      nl : begin writeln(addW); lw := '' end;
      else ew := ew + c
    end;
  end;
  readln;
end.
