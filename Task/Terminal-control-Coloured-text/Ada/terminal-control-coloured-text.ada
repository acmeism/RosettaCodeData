with Ada.Text_Io;

with Ansi;

procedure Coloured  is
   use Ada.Text_Io;
   subtype Ansi_Colors is Ansi.Colors
     range Ansi.Black .. Ansi.Colors'Last;  -- Avoid default
begin
   for Fg_Color in Ansi_Colors loop
      Put ("Rosetta ");
      Put (Ansi.Foreground (Fg_Color));
      for Bg_Color in Ansi_Colors loop
         Put (Ansi.Background (Bg_Color));
         Put ("Code");
      end loop;
      Put (Ansi.Reset);
      New_Line;
   end loop;
end Coloured;
