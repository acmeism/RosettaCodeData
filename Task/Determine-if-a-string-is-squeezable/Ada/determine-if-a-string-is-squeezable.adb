with Ada.Text_IO; use Ada.Text_IO;
procedure Test_Squeezable is
   procedure Squeeze (S : in String; C : in Character) is
      Res : String (1 .. S'Length);
      Len : Natural := 0;
   begin
      Put_Line ("Character to be squeezed: '" & C & "'");
      Put_Line ("Input  = <<<" & S & ">>>, length =" & S'Length'Image);
      for I in S'Range loop
         if Len = 0 or else (S(I) /= Res(Len) or S(I) /= C) then
            Len := Len + 1;
            Res(Len) := S(I);
         end if;
      end loop;
      Put_Line ("Output = <<<" & Res (1 .. Len) & ">>>, length =" & Len'Image);
   end Squeeze;
begin
   Squeeze ("", ' ');
   Squeeze ("""If I were two-faced, would I be wearing this one?"" --- Abraham Lincoln ", '-');
   Squeeze ("..1111111111111111111111111111111111111111111111111111111111111117777888", '7');
   Squeeze ("I never give 'em hell, I just tell the truth, and they think it's hell. ", '.');
   Squeeze ("                                                    --- Harry S Truman  ", ' ');
   Squeeze ("                                                    --- Harry S Truman  ", '-');
   Squeeze ("                                                    --- Harry S Truman  ", 'r');
end Test_Squeezable;
