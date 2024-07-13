PROGRAM Symmetric_difference;

TYPE
  TName = (Bob, Jim, John, Mary, Serena);
  TList = SET OF TName;

PROCEDURE Put(txt : String; ResSet : TList);
VAR
  I : TName;

BEGIN
  Write(txt);
  FOR I IN ResSet DO Write(I,' ');
  WriteLn
END;

VAR
  ListA : TList = [John, Bob, Mary, Serena];
  ListB : TList = [Jim, Mary, John, Bob];

BEGIN
  Put('ListA          -> ', ListA);
  Put('ListB          -> ', ListB);
  Put('ListA >< ListB -> ', (ListA - ListB) + (ListB - ListA));
  Put('ListA -  ListB -> ', ListA -  ListB);
  Put('ListB -  ListA -> ', ListB -  ListA);
  ReadLn;
END.
