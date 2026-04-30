function Diff (Left, Right : Image) return Float is
   Offs_I : constant Integer := Right'First (1) - Left'First (1);
   Offs_J : constant Integer := Right'First (2) - Left'First (2);
   Sum : Count := 0;
begin
   if Left'Length (1) /= Right'Length (1) or else Left'Length (2) /= Right'Length (2) then
      raise Constraint_Error;
   end if;
   for I in Left'Range (1) loop
      for J in Left'Range (2) loop
         Sum := Sum + (Left (I, J) - Right (I + Offs_I, J + Offs_J));
      end loop;
   end loop;
   return Float (Sum) / (3.0 * Float (Left'Length (1) * Left'Length (2)));
end Diff;
