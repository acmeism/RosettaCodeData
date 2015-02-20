program LookAndSayDemo(input, output);
{$IFDEF FPC}
  {$Mode Delphi}  // using result
  {$optimization ON}
// i3-4330 3.5 Ghz
//  {$CodeAlign proc=16,loop=8} //2,6 secs
  {$CodeAlign proc=16,loop=1}  //1,6 secs so much faster ???
{$ENDIF}

uses
  SysUtils;
const
  cntChar : array[1..9] of char =
           ('1','2','3','4','5','6','7','8','9');

function LookAndSay2 (const s: string): string;
//using pChar for result
var
  source,
  destin : pChar;
  len,
  idxFrom,
  idxTo :  integer;
  cnt: integer;

  item: char;
begin
  idxFrom := length(s);
  source := @s[1];

  //adjust length of result
  len := round(length(s)* 1.306+10);
  setlength(result,len);
  destin := @result[1];
  dec(destin);

  idxto := 1;
  item := source^;
  inc(source);
  cnt := 1;
  for idxFrom := idxFrom downto 2 do
  begin
    if item <> source^ then
    begin
      destin[idxTo]  := cntChar[cnt];
      destin[idxTo+1]:= item;
      item := source^;
      cnt := 1;
      inc(idxto,2);
    end
    else
      inc(cnt);
    inc(source);
  end;
  destin[idxTo] := cntChar[cnt];
  destin[idxTo+1]:= item;
  setlength(result,idxto+1);
end;

var
  number: string;
  l1,l2,
  i : integer;
begin
  number := '1';
  writeln(number);
  writeln(1:4,length(number):16,1/1:10:6);

  For i := 2 to 70 do
  begin
    l1 := length(number);
    number := LookAndSay2(number);
    l2 := length(number);
    IF i <10 then
      writeln(number);
    writeln(i:4,length(number):16,l2/l1:10:6);
  end;
end.
