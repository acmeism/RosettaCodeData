with Ada.Text_Io; use Ada.Text_Io;

procedure Tasking_99_Bottles is
   subtype Num_Bottles is Natural range 1..99;
   task Print is
      entry Set (Num_Bottles);
   end Print;
   task body Print is
      Num : Natural;
   begin
      for I in reverse Num_Bottles'range loop
         select
         accept
            Set(I) do -- Rendezvous with Counter task I
               Num := I;
            end Set;
            Put_Line(Integer'Image(Num) & " bottles of beer on the wall");
            Put_Line(Integer'Image(Num) & " bottles of beer");
            Put_Line("Take one down, pass it around");
            Put_Line(Integer'Image(Num - 1) & " bottles of beer on the wall");
            New_Line;
         or terminate; -- end when all Counter tasks have completed
         end select;
      end loop;
   end Print;
   task type Counter(I : Num_Bottles);
   task body Counter is
   begin
      Print.Set(I);
   end Counter;
   type Task_Access is access Counter;

   Task_List : array(Num_Bottles) of Task_Access;

begin
   for I in Task_List'range loop -- Create 99 Counter tasks
      Task_List(I) := new Counter(I);
   end loop;
end Tasking_99_Bottles;
