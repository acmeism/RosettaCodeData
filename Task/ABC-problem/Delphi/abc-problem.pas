program ABC;
{$APPTYPE CONSOLE}

uses SysUtils;

type
  TBlock = set of char;

const
  TheBlocks : array [0..19] of TBlock =
  (
    [ 'B', 'O' ],    [ 'X', 'K' ],    [ 'D', 'Q' ],    [ 'C', 'P' ],    [ 'N', 'A' ],
    [ 'G', 'T' ],    [ 'R', 'E' ],    [ 'T', 'G' ],    [ 'Q', 'D' ],    [ 'F', 'S' ],
    [ 'J', 'W' ],    [ 'H', 'U' ],    [ 'V', 'I' ],    [ 'A', 'N' ],    [ 'O', 'B' ],
    [ 'E', 'R' ],    [ 'F', 'S' ],    [ 'L', 'Y' ],    [ 'P', 'C' ],    [ 'Z', 'M' ]
  );

function SolveABC(Target : string; Blocks : array of TBlock) : boolean;
var
  iChr : integer;
  Used : array [0..19] of boolean;

  function FindUnused(TargetChr : char) : boolean;  // Nested routine
  var
    iBlock : integer;
  begin
    Result := FALSE;
    for iBlock := low(Blocks) to high(Blocks) do
      if (not Used[iBlock]) and ( TargetChr in Blocks[iBlock] ) then
      begin
        Result := TRUE;
        Used[iBlock] := TRUE;
        Break;
      end;
  end;

begin
  FillChar(Used, sizeof(Used), ord(FALSE));
  Result := TRUE;
  iChr := 1;
  while Result and (iChr <= length(Target)) do
    if FindUnused(Target[iChr]) then inc(iChr)
                                else Result := FALSE;
end;

procedure CheckABC(Target : string);
begin
  if SolveABC(uppercase(Target), TheBlocks) then
    writeln('Can make ' + Target)
  else
    writeln('Can NOT make ' + Target);
end;

begin
  CheckABC('A');
  CheckABC('BARK');
  CheckABC('BOOK');
  CheckABC('TREAT');
  CheckABC('COMMON');
  CheckABC('SQUAD');
  CheckABC('CONFUSE');
  readln;
end.
