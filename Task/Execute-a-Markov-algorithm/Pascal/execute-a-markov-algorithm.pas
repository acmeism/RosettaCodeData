program InterpretMA;
{$mode objfpc}{$h+}{$j-}{$b-}
uses
  SysUtils;

type
  TRule = record
    Pattern, Replacement: string;
    Terminating: Boolean;
  end;

function ParseMA(const aScheme: string; out aRules: specialize TArray<TRule>): Boolean;
  function ParseLine(const s: string; out r: TRule): Boolean;
  var
    Terms: TStringArray;
  begin
    Terms := s.Split([' -> ']);
    if Length(Terms) <> 2 then exit(False);
    r.Pattern := Terms[0].Trim;
    r.Replacement := Terms[1].Trim;
    r.Terminating := False;
    if (r.Replacement <> '') and (r.Replacement[1] = '.') then begin
      r.Terminating := True;
      Delete(r.Replacement, 1, 1);
    end;
    Result := True;
  end;
var
  Lines: TStringArray;
  s: string;
  I: Integer;
begin
  aRules := nil;
  if aScheme = '' then exit(False);
  Lines := aScheme.Split([LineEnding], TStringSplitOptions.ExcludeEmpty);
  if Lines = nil then exit(False);
  SetLength(aRules, Length(Lines));
  I := 0;
  for s in Lines do begin
    if s[1] = '#' then continue;
    if not ParseLine(s, aRules[I]) then exit(False);
    Inc(I);
  end;
  SetLength(aRules, I);
  Result := True;
end;

function ExecuteMA(const aScheme, aInput: string): string;
var
  Rules: array of TRule;
  r: TRule;
  Applied: Boolean;
begin
  if not ParseMA(aScheme.Replace(#9, ' ', [rfReplaceAll]), Rules) then
    exit('Error while parsing MA scheme');
  Result := aInput;
  repeat
    Applied := False;
    for r in Rules do begin
      if r.Pattern = '' then begin
          Result := r.Replacement + Result;
          Applied := True;
      end else begin
        Applied := Result.IndexOf(r.Pattern) >= 0;
        if Applied then
          Result := Result.Replace(r.Pattern, r.Replacement);
        end;
      if Applied then begin
        if r.Terminating then exit;
        break;
      end;
    end;
  until not Applied;
end;

type
  TTestEntry = record
    Scheme, Input, Output: string;
  end;

const
  LE = LineEnding;
  TestSet: array[1..5] of TTestEntry = (
    (Scheme:
      '# This rules file is extracted from Wikipedia: ' +LE+
      '# http://en.wikipedia.org/wiki/Markov_Algorithm' +LE+
      'A -> apple'                                      +LE+
      'B -> bag'                                        +LE+
      'S -> shop'                                       +LE+
      'T -> the'                                        +LE+
      'the shop -> my brother'                          +LE+
      'a never used -> .terminating rule';
    Input: 'I bought a B of As from T S.'; Output: 'I bought a bag of apples from my brother.'),
    (Scheme:
      '# Slightly modified from the rules on Wikipedia' +LE+
      'A -> apple'                                      +LE+
      'B -> bag'                                        +LE+
      'S -> .shop'                                      +LE+
      'T -> the'                                        +LE+
      'the shop -> my brother'                          +LE+
      'a never used -> .terminating rule';
    Input: 'I bought a B of As from T S.'; Output: 'I bought a bag of apples from T shop.'),
    (Scheme:
      '# BNF Syntax testing rules'                      +LE+
      'A -> apple'                                      +LE+
      'WWWW -> with'                                    +LE+
      'Bgage -> ->.*'                                   +LE+
      'B -> bag'                                        +LE+
      '->.* -> money'                                   +LE+
      'W -> WW'                                         +LE+
      'S -> .shop'                                      +LE+
      'T -> the'                                        +LE+
      'the shop -> my brother'                          +LE+
      'a never used -> .terminating rule';
    Input: 'I bought a B of As W my Bgage from T S.'; Output: 'I bought a bag of apples with my money from T shop.'),
    (Scheme:
      '### Unary Multiplication Engine, for testing Markov Algorithm implementations' +LE+
      '### By Donal Fellows.'                           +LE+
      '# Unary addition engine'                         +LE+
      '_+1 -> _1+'                                      +LE+
      '1+1 -> 11+'                                      +LE+
      '# Pass for converting from the splitting of multiplication into ordinary' +LE+
      '# addition'                                      +LE+
      '1! -> !1'                                        +LE+
      ',! -> !+'                                        +LE+
      '_! -> _'                                         +LE+
      '# Unary multiplication by duplicating left side, right side times' +LE+
      '1*1 -> x,@y'                                     +LE+
      '1x -> xX'                                        +LE+
      'X, -> 1,1'                                       +LE+
      'X1 -> 1X'                                        +LE+
      '_x -> _X'                                        +LE+
      ',x -> ,X'                                        +LE+
      'y1 -> 1y'                                        +LE+
      'y_ -> _'                                         +LE+
      '# Next phase of applying'                        +LE+
      '1@1 -> x,@y'                                     +LE+
      '1@_ -> @_'                                       +LE+
      ',@_ -> !_'                                       +LE+
      '++ -> +'                                         +LE+
      '# Termination cleanup for addition'              +LE+
      '_1 -> 1'                                         +LE+
      '1+_ -> 1'                                        +LE+
      '_+_ -> ';
    Input: '_1111*11111_'; Output: '11111111111111111111'),
    (Scheme:
      '# Turing machine: three-state busy beaver'       +LE+
      '#'                                               +LE+
      '# state A, symbol 0 => write 1, move right, new state B' +LE+
      'A0 -> 1B'                                        +LE+
      '# state A, symbol 1 => write 1, move left, new state C'  +LE+
      '0A1 -> C01'                                      +LE+
      '1A1 -> C11'                                      +LE+
      '# state B, symbol 0 => write 1, move left, new state A'  +LE+
      '0B0 -> A01'                                      +LE+
      '1B0 -> A11'                                      +LE+
      '# state B, symbol 1 => write 1, move right, new state B' +LE+
      'B1 -> 1B'                                        +LE+
      '# state C, symbol 0 => write 1, move left, new state B'  +LE+
      '0C0 -> B01'                                      +LE+
      '1C0 -> B11'                                      +LE+
      '# state C, symbol 1 => write 1, move left, halt' +LE+
      '0C1 -> H01'                                      +LE+
      '1C1 -> H11';
    Input: '000000A000000'; Output: '00011H1111000')
  );
  E_FMT = 'test #%d: expected "%s", but got "%s"';
var
  e: TTestEntry;
  Result: string;
  I: Integer = 1;
  Failed: Integer = 0;
begin
  for e in TestSet do begin
    Result := ExecuteMA(e.Scheme, e.Input);
    if Result <> e.Output then begin
      WriteLn(Format(E_FMT, [I, e.Output, Result]));
      Inc(Failed);
    end;
    Inc(I);
  end;
  WriteLn('tests completed: ', Length(TestSet), ', failed: ', Failed);
end.
