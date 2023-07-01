with Ada.Text_IO;

procedure Puzzle_Square_4 is

   procedure Four_Rings (Low, High : in Natural; Unique, Show : in Boolean) is
      subtype Test_Range is Natural range Low .. High;

      type Value_List is array (Positive range <>) of Natural;
      function Is_Unique (Values : Value_List) return Boolean is
         Count : array (Test_Range) of Natural := (others => 0);
      begin
         for Value of Values loop
            Count (Value) := Count (Value) + 1;
            if Count (Value) > 1 then
               return False;
            end if;
         end loop;
         return True;
      end Is_Unique;

      function Is_Valid (A,B,C,D,E,F,G : in Natural) return Boolean is
         Ring_1 : constant Integer := A + B;
         Ring_2 : constant Integer := B + C + D;
         Ring_3 : constant Integer := D + E + F;
         Ring_4 : constant Integer := F + G;
      begin
         return
           Ring_1 = Ring_2 and
           Ring_1 = Ring_3 and
           Ring_1 = Ring_4;
      end Is_Valid;

      use Ada.Text_IO;
      Count : Natural := 0;
   begin
      for A in Test_Range loop
         for B in Test_Range loop
            for C in Test_Range loop
               for D in Test_Range loop
                  for E in Test_Range loop
                     for F in Test_Range loop
                        for G in Test_Range loop
                           if Is_Valid (A,B,C,D,E,F,G) then
                              if not Unique or (Unique and Is_Unique ((A,B,C,D,E,F,G))) then
                                 Count := Count + 1;
                                 if Show then
                                    Put_Line (A'Image & B'Image & C'Image & D'Image & E'Image & F'Image & G'Image);
                                 end if;
                              end if;
                           end if;
                        end loop;
                     end loop;
                  end loop;
               end loop;
            end loop;
         end loop;
      end loop;
      Put_Line ("There are " & Count'Image &
                  (if Unique then " unique " else " non-unique ") &
                    "solutions in " & Low'Image & " .." & High'Image);
      New_Line;
   end Four_Rings;

begin
   Four_Rings (Low => 1, High => 7, Unique => True,  Show => True);
   Four_Rings (Low => 3, High => 9, Unique => True,  Show => True);
   Four_Rings (Low => 0, High => 9, Unique => False, Show => False);
end Puzzle_Square_4;
