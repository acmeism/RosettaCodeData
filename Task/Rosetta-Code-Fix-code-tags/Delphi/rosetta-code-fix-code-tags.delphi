program Fix_code_tags;

{$APPTYPE CONSOLE}

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.RegularExpressions;

const
  LANGS: array of string = ['abap', 'actionscript', 'actionscript3', 'ada',
    'apache', 'applescript', 'apt_sources', 'asm', 'asp', 'autoit', 'avisynth',
    'bash', 'basic4gl', 'bf', 'blitzbasic', 'bnf', 'boo', 'c', 'caddcl',
    'cadlisp', 'cfdg', 'cfm', 'cil', 'c_mac', 'cobol', 'cpp', 'cpp-qt', 'csharp',
    'css', 'd', 'delphi', 'diff', '_div', 'dos', 'dot', 'eiffel', 'email',
    'fortran', 'freebasic', 'genero', 'gettext', 'glsl', 'gml', 'gnuplot', 'go',
    'groovy', 'haskell', 'hq9plus', 'html4strict', 'idl', 'ini', 'inno',
    'intercal', 'io', 'java', 'java5', 'javascript', 'kixtart', 'klonec',
    'klonecpp', 'latex', 'lisp', 'lolcode', 'lotusformulas', 'lotusscript',
    'lscript', 'lua', 'm68k', 'make', 'matlab', 'mirc', 'modula3', 'mpasm',
    'mxml', 'mysql', 'nsis', 'objc', 'ocaml', 'ocaml-brief', 'oobas', 'oracle11',
    'oracle8', 'pascal', 'per', 'perl', 'php', 'php-brief', 'pic16',
    'pixelbender', 'plsql', 'povray', 'powershell', 'progress', 'prolog',
    'providex', 'python', 'qbasic', 'rails', 'reg', 'robots', 'ruby', 'sas',
    'scala', 'scheme', 'scilab', 'sdlbasic', 'smalltalk', 'smarty', 'sql', 'tcl',
    'teraterm', 'text', 'thinbasic', 'tsql', 'typoscript', 'vb', 'vbnet',
    'verilog', 'vhdl', 'vim', 'visualfoxpro', 'visualprolog', 'whitespace',
    'winbatch', 'xml', 'xorg_conf', 'xpp', 'z80'];

procedure repl(const Match: TMatch; var code: ansistring);

  procedure replace(_new: ansistring);
  begin
    code := StringReplace(code, Match.Value, '<' + _new + '>', [rfReplaceAll]);
  end;

begin
  if Match.Value = '/code' then
  begin
    replace('/lang');
    exit;
  end;

  if Match.Value = '</code>' then
  begin
    replace('/lang');
    exit;
  end;

  var mid := Lowercase(Trim(copy(Match.Value, 2, length(Match.Value) - 2)));

  for var lg in LANGS do
  begin
    if mid = lg then
    begin
      replace(format('lang %s', [lg]));
      exit;
    end;

    if mid[1] = '/' then
    begin
      replace('/lang');
      exit;
    end;

    if (pos('code', mid) = 1) and (copy(mid, 6, length(mid) - 2) = lg) then
    begin
      replace(format('lang %s', [lg]));
      exit;
    end;
  end;
end;

function Lang(input: ansistring): ansistring;
var
  reg: Tregex;
  match: TMatch;
begin
  reg := TRegex.Create('<[^>]+>');
  Result := input;
  for match in reg.Matches(input) do
    Repl(match, Result);
end;

function ReadAll: Ansistring;
var
  Buffer: array[0..1000] of byte;
  StdIn: TStream;
  Count: Integer;
  buf: Ansistring;
begin
  StdIn := THandleStream.Create(GetStdHandle(STD_INPUT_HANDLE));
  Result := '';
  while True do
  begin
    Count := StdIn.Read(Buffer, 1000);
    if Count = 0 then
      Break;
    SetLength(buf, Count);
    CopyMemory(@buf[1], @Buffer[0], Count);
    Result := Result + buf;
  end;
  StdIn.Free;
end;

procedure Fix();
var
  input, output: ansistring;
begin
  input := ReadAll;
  output := Lang(input);
  writeln(output);
end;

begin
  Fix;
end.
