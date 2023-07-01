program WordWheel;

{$mode objfpc}{$H+}

uses
  SysUtils;

const
  WheelSize = 9;
  MinLength = 3;
  WordListFN = 'unixdict.txt';

procedure search(Wheel : string);
var
  Allowed, Required, Available, w : string;
  Len, i, p : integer;
  WordFile : TextFile;
  Match : boolean;
begin
  AssignFile(WordFile, WordListFN);
  try
    Reset(WordFile);
  except
    writeln('Could not open dictionary file: ' + WordListFN);
    exit;
  end;
  Allowed := LowerCase(Wheel);
  Required := copy(Allowed, 5, 1);  { central letter is required }
  while not eof(WordFile) do
    begin
      readln(WordFile, w);
      Len := length(w);
      if (Len < MinLength) or (Len > WheelSize) then continue;
      if pos(Required, w) = 0 then continue;
      Available := Allowed;
      Match := True;
      for i := 1 to Len do
        begin
          p := pos(w[i], Available);
          if p > 0 then
            { prevent re-use of letter }
            delete(Available, p, 1)
          else
            begin
              Match := False;
              break;
            end;
        end;
      if Match then
        writeln(w);
    end;
  CloseFile(WordFile);
end;

{ exercise the procedure }
begin
  search('NDE' + 'OKG' + 'ELW');
end.
