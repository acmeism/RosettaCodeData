with Generic_Heapsort;
with Ada.Text_Io; use Ada.Text_Io;

procedure Test_Generic_Heapsort is
   type Days is (Sun, Mon, Tue, Wed, Thu, Fri, Sat);
   type Days_Col is array(Days range <>) of Natural;
   procedure Sort is new Generic_Heapsort(Natural, Days, Days_Col);
   Week : Days_Col := (5, 2, 7, 3, 4, 9, 1);
begin
   for I in Week'range loop
      Put(Days'Image(I) & ":" & Natural'Image(Week(I)) & " ");
   end loop;
   New_Line;
   Sort(Week);
   for I in Week'range loop
      Put(Days'Image(I) & ":" & Natural'Image(Week(I))& " ");
   end loop;
   New_Line;
end Test_Generic_Heapsort;
