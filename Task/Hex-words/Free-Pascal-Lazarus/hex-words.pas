{$mode ObjFPC}{$H+}
uses
  strutils, classes, sysutils;

const
  FNAME = 'unixdict.txt';

type
  PRec = ^TRec;
  TRec = record
    Root: Uint32;
    Base10: UInt32;
    Hex: String;
  end;

  TRecList = TList;

function DigitalRoot(n: UInt32): UInt32;
{returns the digital root}
begin
  if n < 10 then
    Result := n
  else
    Result := DigitalRoot(n div 10 + n mod 10);
end;

function IsHexWord(const str: string): Boolean;
{returns TRUE if string is a hexword}
var
  ch: Char;
begin
  for ch in str do
    if not (ch in ['a', 'b', 'c', 'd', 'e', 'f']) then
      Exit(FALSE);
  Result := TRUE;
end;

function Has4Distinctive(const str: string): Boolean;
{returns TRUE if string contains 4 or more distinctive charachters}
var
  arr: array['a'..'f'] of Boolean;
  ch: Char;
  counter: Integer;
begin
  for ch := 'a' to 'f' do
    arr[ch] := FALSE;
  counter := 0;
  for ch in str do
    if not arr[ch] then
    begin
      arr[ch] := TRUE;
      Inc(counter);
      if counter = 4 then
        Exit(TRUE);
    end;
  Result := FALSE;
end;

procedure PurgeRecList(var list: TRecList);
{remove every record that doesn have atleast 4 distinctive charachters}
var
  rec: PRec;
  i: Integer;
begin
  for i := Pred(list.Count) downto 0 do
  begin
    rec := list[i];
    if not Has4Distinctive(rec^.Hex) then
      list.Delete(i);
  end;
end;

procedure CreateRecList(var reclist: TRecList; list: TStringList);
{create list of records that have 4 or more charachters and are hexwords}
var
  str: string;
  aPrec: PRec;
begin
  for str in list do
    if (Length(str) > 3) and IsHexWord(str) then
    begin
      New(aPrec);
      aPrec^.Base10 := Hex2Dec(str);
      aPrec^.Root := DigitalRoot(aPrec^.Base10);
      aPrec^.Hex := str;
      reclist.Add(aPrec);
    end;
end;

function SortOnRoot(Item1, Item2: Pointer): Integer;
{sort the list on Root}
begin
  Result := PRec(Item1)^.Root - PRec(Item2)^.Root;
end;

function SortOnBase10(Item1, Item2: Pointer): Integer;
{sort the list on Base 10}
begin
  Result := PRec(Item2)^.Base10 - PRec(Item1)^.Base10;
end;

procedure PrintList(list: TRecList);
var
  rec: PRec;
begin
  Writeln('Root':4, 'Base 10':10, 'Hex Word':10);
  for rec in list do
    Writeln(rec^.Root:4, rec^.Base10:10, rec^.Hex:10);
  Writeln('Total Count:', list.Count);
  Writeln;
end;

var
  list: TStringList;
  RecList: TRecList;

begin
  list := TStringList.Create;
  list.LoadFromFile(FNAME);
  RecList := TRecList.Create;
  CreateRecList(RecList, list); {create list of records purging first set}
  list.Free;  					{no longer need for the dictionary}
  RecList.Sort(@SortOnRoot); 	{sort list on the root}
  PrintList(RecList); 			{print the list}
  PurgeRecList(RecList); 		{purge list second set}
  RecList.Sort(@SortOnBase10); 	{sort on base 10}
  PrintList(RecList); 			{print the list}
  RecList.Free; 				{free the memory}
end.
