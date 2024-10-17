program RPG_Attributes_Generator;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TListOfInt = class(TList<Integer>)
  public
    function Sum: Integer;
    function FindAll(func: Tfunc<Integer, Boolean>): TListOfInt;
    function Join(const sep: string): string;
  end;

{ TListOfInt }

function TListOfInt.FindAll(func: Tfunc<Integer, Boolean>): TListOfInt;
var
  Item: Integer;
begin
  Result := TListOfInt.Create;
  if Assigned(func) then
    for Item in self do
      if func(Item) then
        Result.Add(Item);
end;

function TListOfInt.Join(const sep: string): string;
var
  Item: Integer;
begin
  Result := '';
  for Item in self do
    if Result.IsEmpty then
      Result := Item.ToString
    else
      Result := Result + sep + Item.ToString;
end;

function TListOfInt.Sum: Integer;
var
  Item: Integer;
begin
  Result := 0;
  for Item in self do
    Inc(Result, Item);
end;

function GetThree(n: integer): TListOfInt;
var
  i: Integer;
begin
  Randomize;
  Result := TListOfInt.Create;
  for i := 0 to 3 do
    Result.Add(Random(n) + 1);
  Result.Sort;
  Result.Delete(0);
end;

function GetSix(): TListOfInt;
var
  i: Integer;
  tmp: TListOfInt;
begin
  Result := TListOfInt.Create;
  for i := 0 to 5 do
  begin
    tmp := GetThree(6);
    Result.Add(tmp.Sum);
    tmp.Free;
  end;
end;

const
  GOOD_STR: array[Boolean] of string = ('low', 'good');
  SUCCESS_STR: array[Boolean] of string = ('failure', 'success');

var
  good: Boolean;
  gs, hvcList: TListOfInt;
  gss, hvc: Integer;

begin
  good := false;
    repeat
    gs := GetSix();
    gss := gs.Sum;

    hvcList := gs.FindAll(
      function(x: Integer): Boolean
      begin
        result := x > 14;
      end);
    hvc := hvcList.Count;
    hvcList.Free;

    Write(Format('Attribs: %s, sum=%d, (%s sum, high vals=%d)', [gs.Join(', '),
      gss, GOOD_STR[gss >= 75], hvc]));

    good := (gss >= 75) and (hvc > 1);

    Writeln(' - ', SUCCESS_STR[good]);

    gs.Free;
  until good;
  Readln;
end.
