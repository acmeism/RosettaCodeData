pragma Ada_2022;
with Ada.Command_Line;  use Ada.Command_Line;
with Ada.Text_IO;       use Ada.Text_IO;
procedure Abelian_Sandpile is
   type Grid_2D is array (Positive range <>, Positive range <>) of Natural;

   procedure Write_PPM (Grid : Grid_2D; Filename : String) is
      PPM_File : File_Type;
   begin
      Create (PPM_File, Out_File, Filename);
      Put_Line (PPM_File, "P3");
      Put_Line (PPM_File, Grid'Length (1)'Image & Grid'Length (2)'Image);
      Put_Line (PPM_File, "7");
      for Y in 1 .. Grid'Length (2) loop
         for X in 1 .. Grid'Length (1) loop
            case Grid (X, Y) is
               when 0 => Put_Line (PPM_File, "0 0 0");      --  black
               when 1 => Put_Line (PPM_File, "0 7 0");      --  green
               when 2 => Put_Line (PPM_File, "7 0 7");      --  lilac
               when 3 => Put_Line (PPM_File, "7 7 0");      --  yellow
               when others => Put_Line (PPM_File, "0 0 7"); --  blue, shouldn't happen
            end case;
         end loop;
      end loop;
      Close (PPM_File);
   end Write_PPM;
begin
   if Argument_Count /= 2 then
      Put_Line ("Error: Must specify <Sandpile Height> <Grid Size>");
   else
      declare
         Initial_Height : constant Positive := Positive'Value (Argument (1));
         Grid_Size      : constant Positive := Positive'Value (Argument (2));
         Sandpile       : Grid_2D (1 .. Grid_Size, 1 .. Grid_Size) := [others => [others => 0]];
         More_To_Do     : Boolean := True;
         Overspill      : Natural;
      begin
         Sandpile (Grid_Size / 2, Grid_Size / 2) := Initial_Height;
         while More_To_Do loop
            More_To_Do := False;
            for X in 1 .. Grid_Size loop
               for Y in 1 .. Grid_Size loop
                  if Sandpile (X, Y) >= 4 then
                     Overspill := Sandpile (X, Y) / 4;
                     Sandpile (X, Y) :=  @ mod 4;
                     More_To_Do := True;
                     if X > 1 then
                        Sandpile (X - 1, Y) := @ + Overspill;
                     end if;
                     if Y > 1 then
                        Sandpile (X, Y - 1) := @ + Overspill;
                     end if;
                     if X < Grid_Size then
                        Sandpile (X + 1, Y) := @ + Overspill;
                     end if;
                     if Y < Grid_Size then
                        Sandpile (X, Y + 1) := @ + Overspill;
                     end if;
                  end if;
               end loop;
            end loop;
         end loop;
         if Grid_Size < 16 then Put_Line (Sandpile'Image); end if;
         Write_PPM (Sandpile, "sandpile.ppm");
      end;
   end if;
end Abelian_Sandpile;
