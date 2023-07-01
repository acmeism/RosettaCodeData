PROGRAM Symmetric_difference;

uses
  System.Typinfo;

TYPE
  TName = (Bob, Jim, John, Mary, Serena);
  TList = SET OF TName;

  TNameHelper = record helper for TName
    FUNCTION ToString(): string;
  end;

  { TNameHlper }

FUNCTION TNameHelper.ToString: string;
BEGIN
  Result := GetEnumName(TypeInfo(TName), Ord(self));
END;

PROCEDURE Put(txt: String; ResSet: TList);
VAR
  I: TName;

BEGIN
  Write(txt);
  FOR I IN ResSet DO
    Write(I.ToString, ' ');
  WriteLn;
END;

VAR
  ListA: TList = [John, Bob, Mary, Serena];
  ListB: TList = [Jim, Mary, John, Bob];

BEGIN
  Put('ListA          -> ', ListA);
  Put('ListB          -> ', ListB);
  Put('ListA >< ListB -> ', (ListA - ListB) + (ListB - ListA));
  Put('ListA -  ListB -> ', ListA - ListB);
  Put('ListB -  ListA -> ', ListB - ListA);
  ReadLn;
END.
