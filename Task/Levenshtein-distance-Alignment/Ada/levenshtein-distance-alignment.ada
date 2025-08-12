with Ada.Assertions,
     Ada.Text_IO;

procedure Levenschtein_Alignment is
   type Levenschtein_Array is array (Natural range <>, Natural range <>) of Natural;

   type Levenschtein_Matrix (S, T : Natural) is record
      Source : String (1 .. S);
      Target : String (1 .. T);
      Matrix : Levenschtein_Array (0 .. S, 0 .. T);
   end record;

   function Make (S, T : String) return Levenschtein_Matrix is
      L : Levenschtein_Matrix (S'Length, T'Length);
   begin
      L.Source := S;
      L.Target := T;
      L.Matrix (0, 0) := 0;

      for I in S'Range loop
         L.Matrix (I, 0) := I;
      end loop;

      for I in T'Range loop
         L.Matrix (0, I) := I;
      end loop;

      return L;
   end Make;

   Place_Palace : Levenschtein_Matrix := Make ("place", "palace");
   Rosettacode_Raisethysword : Levenschtein_Matrix := Make ("rosettacode", "raisethysword");

   procedure Fill (L : in out Levenschtein_Matrix) is
      Cost : Natural;
   begin
      for J in L.Target'Range loop
         for I in L.Source'Range loop
            if L.Source (I) = L.Target (J) then
               Cost := 0;
            else
               Cost := 1;
            end if;

            L.Matrix (I, J) := Natural'Min
              (Cost + L.Matrix (I - 1, J - 1), --  Substitution
               Natural'Min
                 (1 + L.Matrix (I - 1, J), --  Deletion
                  1 + L.Matrix (I, J - 1))); --  Insertion
         end loop;
      end loop;
   end Fill;

   --  For convenience, assume Source'Length <= Target'Length
   procedure Show (L : Levenschtein_Matrix) is
      Aligned_Source : String (1 .. L.Target'Length);
      I : Natural := L.Source'Length;
      J : Natural := L.Target'Length;
      Min_Dist : Natural;
   begin
      Ada.Assertions.Assert (I <= J);

      for P in reverse 1 .. L.Target'Length loop
         --  Deletion will not happen due to length assumption
         Min_Dist := Natural'Min (L.Matrix (I, J - 1), L.Matrix (I - 1, J - 1));

         if Min_Dist = L.Matrix (I - 1, J - 1) then
            --  Substitution. Fill in source character
            Aligned_Source (P) := L.Source (I);
            I := I - 1;
            J := J - 1;
         elsif Min_Dist = L.Matrix (I, J - 1) then
            --  Insertion. Fill in a wildcard
            Aligned_Source (P) := '-';
            J := J - 1;
         end if;
      end loop;

      Ada.Text_IO.Put_Line (Aligned_Source);
      Ada.Text_IO.Put_Line (L.Target);
   end Show;
begin
   Fill (Place_Palace);
   Show (Place_Palace);

   Fill (Rosettacode_Raisethysword);
   Show (Rosettacode_Raisethysword);
end Levenschtein_Alignment;
