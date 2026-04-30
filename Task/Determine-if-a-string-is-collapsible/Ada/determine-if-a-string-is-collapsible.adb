with Ada.Text_IO; use Ada.Text_IO;
procedure Test_Collapsible is
   procedure Collapse (S : in String) is
      Res : String (1 .. S'Length);
      Len : Natural := 0;
   begin
      Put_Line ("Input  = <<<" & S & ">>>, length =" & S'Length'Image);
      for I in S'Range loop
         if Len = 0 or else S(I) /= Res(Len) then
            Len := Len + 1;
            Res(Len) := S(I);
         end if;
      end loop;
      Put_Line ("Output = <<<" & Res (1 .. Len) & ">>>, length =" & Len'Image);
   end Collapse;
begin
   Collapse ("");
   Collapse ("""If I were two-faced, would I be wearing this one?"" --- Abraham Lincoln ");
   Collapse ("..1111111111111111111111111111111111111111111111111111111111111117777888");
   Collapse ("I never give 'em hell, I just tell the truth, and they think it's hell. ");
   Collapse ("                                                    --- Harry S Truman  ");
end Test_Collapsible;
