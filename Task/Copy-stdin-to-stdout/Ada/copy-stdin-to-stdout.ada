with Ada.Text_IO;

procedure Copy_Stdin_To_Stdout is
   use Ada.Text_IO;
   C : Character;
begin
   while not End_Of_File loop
      Get_Immediate (C);
      Put (C);
   end loop;
end Copy_Stdin_To_Stdout;
