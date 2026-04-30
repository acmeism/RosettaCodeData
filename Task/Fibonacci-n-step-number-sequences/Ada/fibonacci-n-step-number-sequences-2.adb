package body Bonacci is

   function Generate(Start: Sequence; Length: Positive := 10) return Sequence is
   begin
      if Length <= Start'Length then
         return Start(Start'First .. Start'First+Length-1);
      else
         declare
            Sum: Natural := 0;
         begin
            for I in Start'Range loop
               Sum := Sum + Start(I);
            end loop;
            return Start(Start'First)
              & Generate(Start(Start'First+1 .. Start'Last) & Sum, Length-1);
         end;
      end if;
   end Generate;

end Bonacci;
