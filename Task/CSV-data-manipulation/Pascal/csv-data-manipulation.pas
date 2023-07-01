program CSV_Data_Manipulation;
uses Classes, SysUtils;

var s: string;
    ts: tStringList;
    inFile,
    outFile: Text;
    Sum: integer;
    Number: string;

begin

  Assign(inFile,'input.csv');
  Reset(inFile);

  Assign(outFile,'result.csv');
  Rewrite(outFile);

  ts:=tStringList.Create;
  ts.StrictDelimiter:=True;

  // Handle the header
  ReadLn(inFile,s);                     // Read a line from input file
  ts.CommaText:=s;                      // Split it to lines
  ts.Add('SUM');                        // Add a line
  WriteLn(outFile,ts.CommaText);        // Reassemble it with comma as delimiter

  // Handle the data
  while not eof(inFile) do
  begin
    ReadLn(inFile,s);
    ts.CommaText:=s;

    Sum:=0;
    for Number in ts do
      Sum+=StrToInt(Number);

    ts.Add('%D',[Sum]);

    writeln(outFile, ts.CommaText);
  end;
  Close(outFile);
  Close(inFile);
  ts.Free;
end.
