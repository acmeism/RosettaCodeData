program StripComments;

{$APPTYPE CONSOLE}

uses
  SysUtils;

function DoStripComments(const InString: string; const CommentMarker: Char): string;
begin
  Result := Trim(Copy(InString,1,Pos(CommentMarker,InString)-1));
end;

begin
  Writeln('apples, pears # and bananas --> ' + DoStripComments('apples, pears # and bananas','#'));
  Writeln('');
  Writeln('apples, pears ; and bananas --> ' + DoStripComments('apples, pears ; and bananas',';'));
  Readln;
end.
