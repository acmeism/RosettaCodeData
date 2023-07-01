program OneHundredDoors;

{$APPTYPE CONSOLE}

uses
  math, sysutils;

var
   AOpendoors  : String;
   ACloseDoors : String;
   i	       : Integer;

begin
   for i := 1 to 100 do
   begin
      if (sqrt(i) = floor(sqrt(i))) then
        AOpenDoors := AOpenDoors + IntToStr(i) + ';'
      else
        ACloseDoors := ACloseDoors + IntToStr(i) +';';
   end;

   WriteLn('Open doors: ' + AOpenDoors);
   WriteLn('Close doors: ' + ACloseDoors);
end.
