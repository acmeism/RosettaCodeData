with Ada.Command_Line,
     Ada.Text_IO;

with URL;

procedure Test_URL_Decode is
   use Ada.Command_Line, Ada.Text_IO;
begin
   if Argument_Count = 0 then
      Put_Line (URL.Decode ("http%3A%2F%2Ffoo%20bar%2F"));
   else
      for I in 1 .. Argument_Count loop
         Put_Line (URL.Decode (Argument (I)));
      end loop;
   end if;
end Test_URL_Decode;
