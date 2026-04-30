with Ada.Text_IO;

procedure Steps_To_One is
   type Steps_Array is array (Positive range <>) of Natural;
   type Steps (N : Positive) is record
      Div1, Div2, Sub : Positive;
      Tab : Steps_Array (1 .. N);
   end record;

   Table1 : Steps :=
     (
      N => 2000,
      Div1 => 3,
      Div2 => 2,
      Sub => 1,
      Tab => (1 => 0, others => Natural'Last)
     );

   Table2 : Steps :=
     (
      N => 2000,
      Div1 => 3,
      Div2 => 2,
      Sub => 2,
      Tab => (1 => 0, others => Natural'Last)
     );

   procedure Fill (Table : in out Steps) is
      Min_Steps : Natural;
   begin
      for I in 2 .. Table.Tab'Last loop
         Min_Steps := Natural'Last;

         if I mod Table.Div1 = 0 then
            Min_Steps := Natural'Min (Min_Steps, Table.Tab (I / Table.Div1));
         end if;

         if I mod Table.Div2 = 0 then
            Min_Steps := Natural'Min (Min_Steps, Table.Tab (I / Table.Div2));
         end if;

         if I - Table.Sub >= 1 then
            Min_Steps := Natural'Min (Min_Steps, Table.Tab (I - Table.Sub));
         end if;

         Table.Tab (I) := 1 + Min_Steps;
      end loop;
   end Fill;

   procedure Show_Steps (Table : Steps; Limit : Positive) is
      Min_Steps : Natural;
      Trace : Positive;
   begin
      for I in 1 .. Limit loop
         Min_Steps := Table.Tab (I);
         Trace := I;
         Ada.Text_IO.Put (I'Image & " [" & Min_Steps'Image  & " steps ]: ");

         for J in 1 .. Table.Tab (I) loop
            Ada.Text_IO.Put (Trace'Image);
            Min_Steps := Table.Tab (Trace);

            if Trace mod Table.Div1 = 0 and then
               Min_Steps = 1 + Table.Tab (Trace / Table.Div1) then
               Ada.Text_IO.Put (" /" & Table.Div1'Image);
               Trace := Trace / Table.Div1;
            elsif Trace mod Table.Div2 = 0 and then
                  Min_Steps = 1 + Table.Tab (Trace / Table.Div2) then
               Ada.Text_IO.Put ( " /" & Table.Div2'Image);
               Trace := Trace / Table.Div2;
            else
               Ada.Text_IO.Put (" -" & Table.Sub'Image);
               Trace := Trace - Table.Sub;
            end if;

            Ada.Text_IO.Put (" =>");
         end loop;

         Ada.Text_IO.New_Line;
      end loop;
   end Show_Steps;

   procedure Show_Max_Min (Table : Steps) is
      Max_Min : Natural := 0;
   begin
      for I of Table.Tab loop
         Max_Min := Natural'Max (Max_Min, I);
      end loop;

      Ada.Text_IO.Put ("Numbers with maximum minimal steps [" & Max_Min'Image & " ]: ");

      for I in Table.Tab'Range loop
         if Max_Min = Table.Tab (I) then
            Ada.Text_IO.Put (I'Image & ", ");
         end if;
      end loop;

      Ada.Text_IO.New_Line;
   end Show_Max_Min;

begin
   Fill (Table1);
   Show_Steps (Table1, 10);
   Show_Max_Min (Table1);
   Fill (Table2);
   Show_Steps (Table2, 10);
   Show_Max_Min (Table2);
end Steps_To_One;
