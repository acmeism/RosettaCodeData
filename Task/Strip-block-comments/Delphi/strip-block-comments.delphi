program Strip_block_comments;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function BlockCommentStrip(commentStart, commentEnd, sampleText: string): string;
begin
  while ((sampleText.IndexOf(commentStart) > -1) and (sampleText.IndexOf(commentEnd,
    sampleText.IndexOf(commentStart) + commentStart.Length) > -1)) do
  begin
    var start := sampleText.IndexOf(commentStart);
    var _end := sampleText.IndexOf(commentEnd, start + commentStart.Length);
    sampleText := sampleText.Remove(start, (_end + commentEnd.Length) - start);
  end;
  Result := sampleText;
end;

const
  test = '/**' + #10 + '* Some comments' + #10 +
    '* longer comments here that we can parse.' + #10 + '*' + #10 + '* Rahoo ' +
    #10 + '*/' + #10 + 'function subroutine() {' + #10 +
    'a = /* inline comment */ b + c ;' + #10 + '}' + #10 +
    '/*/ <-- tricky comments */' + #10 + '' + #10 + '/**' + #10 +
    '* Another comment.' + #10 + '*/' + #10 + 'function something() {' + #10 + '}';

begin

  writeln(BlockCommentStrip('/*', '*/', test));
  readln;
end.
