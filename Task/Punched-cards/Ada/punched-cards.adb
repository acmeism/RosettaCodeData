with Ada.Text_IO;        use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;

procedure Punched_Cards is

   procedure Punch (Text : String) is
      type Row is range 0..12;
      type Column is array (Row) of Boolean;
      Card : array (1..80) of Column := (others => (others => False));
      procedure Put (J : Row; Prefix : Character := '|') is
      begin
         Put (Prefix);
         for I in 1..80 loop
            if Card (I) (J) then
               Put ('x');
            else
               Put (' ');
            end if;
         end loop;
         Put ("|");
         New_Line;
      end Put;
   begin
      if Text'Length > 80 then
         raise Constraint_Error with "Too many columns";
      end if;
      for I in Text'Range loop
         declare
            procedure Punch (J : Row) is
            begin
               Card (I) (J) := True;
            end Punch;
         begin
            case Text (I) is
               when '&' =>
                  Punch (12);
               when 'A'..'I' =>
                  Punch (12);
                  Punch (Character'Pos (Text (I)) - Character'Pos ('A') + 1);
               when '[' =>
                  Punch (2); Punch (8); Punch (12);
               when '.' =>
                  Punch (3); Punch (8); Punch (12);
               when '<' =>
                  Punch (4); Punch (8); Punch (12);
               when '(' =>
                  Punch (5); Punch (8); Punch (12);
               when '+' =>
                  Punch (6); Punch (8); Punch (12);
               when '!' =>
                  Punch (7); Punch (8); Punch (12);

               when '-' =>
                  Punch (11);
               when 'J'..'R' =>
                  Punch (11);
                  Punch (Character'Pos (Text (I)) - Character'Pos ('J') + 1);
               when ']' =>
                  Punch (2); Punch (8); Punch (11);
               when '$' =>
                  Punch (3); Punch (8); Punch (11);
               when '*' =>
                  Punch (4); Punch (8); Punch (11);
               when ')' =>
                  Punch (5); Punch (8); Punch (11);
               when ';' =>
                  Punch (6); Punch (8); Punch (11);
               when '^' =>
                  Punch (7); Punch (8); Punch (11);

               when '/' =>
                  Punch (0); Punch (1);
               when 'S'..'Z' =>
                  Punch (0);
                  Punch (Character'Pos (Text (I)) - Character'Pos ('S') + 2);
               when '\' =>
                  Punch (2); Punch (8); Punch (0);
               when ',' =>
                  Punch (3); Punch (8); Punch (0);
               when '%' =>
                  Punch (4); Punch (8); Punch (0);
               when '_' =>
                  Punch (5); Punch (8); Punch (0);
               when '>' =>
                  Punch (6); Punch (8); Punch (0);
               when '?' =>
                  Punch (7); Punch (8); Punch (0);

               when ' ' =>
                  null;
               when '0'..'9' =>
                  Punch (Character'Pos (Text (I)) - Character'Pos ('0'));
               when '`' =>
                  Punch (1); Punch (8);
               when ':' =>
                  Punch (2); Punch (8);
               when '#' =>
                  Punch (3); Punch (8);
               when '@' =>
                  Punch (4); Punch (8);
               when ''' =>
                  Punch (5); Punch (8);
               when '=' =>
                  Punch (6); Punch (8);
               when '"' =>
                  Punch (7); Punch (8);

               when 'a'..'i' =>
                  Punch (12); Punch (0);
                  Punch (Character'Pos (Text (I)) - Character'Pos ('a') + 1);

               when '|' =>
                  Punch (12); Punch (11);
               when 'j'..'r' =>
                  Punch (12); Punch (11);
                  Punch (Character'Pos (Text (I)) - Character'Pos ('j') + 1);

               when 's'..'z' =>
                  Punch (11); Punch (0);
                  Punch (Character'Pos (Text (I)) - Character'Pos ('s') + 2);
               when others =>
                  raise Constraint_Error with "Invalid code '" & Text (I) & ''';
            end case;
         end;
      end loop;
      Put_Line (' ' & 80 * "_" & '.');
      Put (12, '/');
      Put (11);
      for J in Row range 0..9 loop
         Put (J);
      end loop;
      Put_Line ('|' & 80 * "_" & '|');
   end Punch;

begin
   Punch ("&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'=""[.<(+|]$*);^\,%_>?");
   Put_Line ("Hello World!");
   Punch ("with Ada.Text_IO;  use Ada.Text_IO;");
   Punch ("procedure Hello is");
   Punch ("begin");
   Punch ("   Put_Line (""Hello World!"");");
   Punch ("end Hello;");
end Punched_Cards;
