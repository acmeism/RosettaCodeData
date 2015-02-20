with Ada.Command_Line, Ada.Text_IO, Prime_Numbers;

procedure Count is
   package Prime_Nums is new Prime_Numbers
     (Number => Natural, Zero => 0, One => 1, Two => 2); use Prime_Nums;

   procedure Put (List : Number_List) is
   begin
      for Index in List'Range loop
         Ada.Text_IO.Put (Integer'Image (List (Index)));
         if Index /= List'Last then
            Ada.Text_IO.Put (" x");
         end if;
      end loop;
   end Put;

   N     : Natural := 1;
   Max_N : Natural := 15; -- the default for Max_N
begin
   if Ada.Command_Line.Argument_Count = 1 then -- read Max_N from command line
      Max_N := Integer'Value (Ada.Command_Line.Argument (1));
   end if; -- else use the default
   loop
      Ada.Text_IO.Put (Integer'Image (N) & ": ");
      Put (Decompose (N));
      Ada.Text_IO.New_Line;
      N := N + 1;
      exit when N > Max_N;
   end loop;
end Count;
