with Ada.Text_IO;

procedure Jaro_Distances is

   type Jaro_Measure is new Float;

   function Jaro_Distance (Left, Right : in String) return Jaro_Measure
   is
      Left_Matches   : array (Left'Range)  of Boolean := (others => False);
      Right_Matches  : array (Right'Range) of Boolean := (others => False);
      Matches        : Natural := 0;
      Transpositions : Natural := 0;
   begin
      if Left'Length = 0 and Right'Length = 0 then
         return 1.000;
      end if;

      declare
         Match_Distance : constant Natural := Natural'Max (Left'Length, Right'Length) / 2 - 1;
      begin
         for L in Left'Range loop
            declare
               First : constant Natural := Natural'Max (Right'First, Right'First + L - Left'First - Match_Distance);
               Last  : constant Natural := Natural'Min (L - Left'First + Match_Distance + Right'First, Right'Last);
            begin
               for R in First .. Last loop
                  if
                    not Right_Matches (R) and
                    Left (L) = Right (R)
                  then
                     Left_Matches (L)  := True;
                     Right_Matches (R) := True;
                     Matches := Matches + 1;
                     exit;
                  end if;
               end loop;
            end;
         end loop;
      end;

      if Matches = 0 then
         return 0.000;
      end if;

      declare
         R : Natural := Right'First;
      begin
         for L in Left'Range loop
            if Left_Matches (L) then
               while not Right_Matches (R) loop
                  R := R + 1;
               end loop;
               if Left (L) /= Right (R) then
                  Transpositions := Transpositions + 1;
               end if;
               R := R + 1;
            end if;
         end loop;
      end;

      declare
         Match  : constant Float := Float (Matches);
         Term_1 : constant Float := Match / Float (Left'Length);
         Term_2 : constant Float := Match / Float (Right'Length);
         Term_3 : constant Float := (Match - Float (Transpositions) / 2.0) / Match;
      begin
         return Jaro_Measure ((Term_1 + Term_2 + Term_3) / 3.0);
      end;
   end Jaro_Distance;

   procedure Show_Jaro (Left, Right :  in String)
   is
      package Jaro_IO is
         new Ada.Text_IO.Float_IO (Jaro_Measure);
      use Ada.Text_IO;

      Distance : constant Jaro_Measure := Jaro_Distance (Left, Right);
   begin
      Jaro_IO.Put (Distance, Fore => 1, Aft => 5, Exp => 0);
      Set_Col (10);  Put (Left);
      Set_Col (22);  Put (Right);
      New_Line;
   end Show_Jaro;

   S1 : constant String := "  MARTHA VS MARHTA  ";
begin
   Show_Jaro ("DWAYNE",    "DUANE");
   Show_Jaro ("DIXON",     "DICKSONX");
   Show_Jaro ("JELLYFISH", "SMELLYFISH");
   Show_Jaro (S1 (3 .. 8), S1 (13 .. 18));
end Jaro_Distances;
