with Ada.Text_IO; use Ada.Text_IO;

procedure Infinities is
   function Sup return Float is -- Only for predefined types
      Result : Float := Float'Last;
   begin
      if not Float'Machine_Overflows then
         Result := Float'Succ (Result);
      end if;
      return Result;
   end Sup;

   function Inf return Float is -- Only for predefined types
      Result : Float := Float'First;
   begin
      if not Float'Machine_Overflows then
         Result := Float'Pred (Result);
      end if;
      return Result;
   end Inf;
begin
   Put_Line ("Supremum" & Float'Image (Sup));
   Put_Line ("Infimum " & Float'Image (Inf));
end Infinities;
