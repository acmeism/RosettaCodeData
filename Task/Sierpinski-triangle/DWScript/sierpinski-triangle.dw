procedure PrintSierpinski(order : Integer);
var
   x, y, size : Integer;
begin
   size := (1 shl order)-1;
   for y:=size downto 0 do begin
      Print(StringOfChar(' ', y));
      for x:=0 to size-y do begin
         if (x and y)=0 then
            Print('* ')
         else Print('  ');
      end;
      PrintLn('');
   end;
end;

PrintSierpinski(4);
