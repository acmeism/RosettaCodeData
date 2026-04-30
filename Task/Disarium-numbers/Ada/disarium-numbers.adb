with Ada.Text_IO;

procedure Disarium_Numbers is

   Disarium_Count : constant := 19;

   function Is_Disarium (N : Natural) return Boolean is
      Nn  : Natural := N;
      Pos : Natural := 0;
      Sum : Natural := 0;
   begin
      while Nn /= 0 loop
         Nn  := Nn / 10;
         Pos := Pos + 1;
      end loop;
      Nn := N;
      while Nn /= 0 loop
         Sum := Sum + (Nn mod 10) ** Pos;
         Nn  := Nn / 10;
         Pos := Pos - 1;
      end loop;
      return N = Sum;
   end Is_Disarium;

   Count : Natural := 0;
begin
   for N in 0 .. Natural'Last loop
      if Is_Disarium (N) then
         Count := Count + 1;
         Ada.Text_IO.Put (N'Image);
      end if;
      exit when Count = Disarium_Count;
   end loop;
end Disarium_Numbers;
