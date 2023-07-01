with Ada.Text_IO;

procedure Square_But_Not_Cube is

   function Is_Cube (N : in Positive) return Boolean is
      Cube : Positive;
   begin
      for I in Positive loop
         Cube := I**3;
         if Cube = N    then  return True;
         elsif Cube > N then  return False;
         end if;
      end loop;
      raise Program_Error;
   end Is_Cube;

   procedure Show (Limit : in Natural) is
      Count  : Natural := 0;
      Square : Natural;
      use Ada.Text_IO;
   begin
      for N in Positive loop
         Square := N**2;
         if not Is_Cube (Square) then
            Count := Count + 1;
            Put (Square'Image);
            exit when Count = Limit;
         end if;
      end loop;
      New_Line;
   end Show;

begin
   Show (Limit => 30);
end Square_But_Not_Cube;
