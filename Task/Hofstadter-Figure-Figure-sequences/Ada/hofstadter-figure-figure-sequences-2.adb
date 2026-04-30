package body Hofstadter_Figure_Figure is

   type Positive_Array is array (Positive range <>) of Positive;

   function FFR(P: Positive) return Positive_Array is
      Figures: Positive_Array(1 .. P+1);
      Space: Positive := 2;
      Space_Index: Positive := 2;
   begin
      Figures(1) := 1;
      for I in 2 .. P loop
         Figures(I) := Figures(I-1) + Space;
         Space := Space+1;
         while Space = Figures(Space_Index) loop
            Space := Space + 1;
            Space_Index := Space_Index + 1;
         end loop;
      end loop;
      return Figures(1 .. P);
   end FFR;

   function FFR(P: Positive) return Positive is
      Figures: Positive_Array(1 .. P) := FFR(P);
   begin
      return Figures(P);
   end FFR;

   function FFS(P: Positive) return Positive_Array is
      Spaces:  Positive_Array(1 .. P);
      Figures: Positive_Array := FFR(P+1);
      J: Positive := 1;
      K: Positive := 1;
   begin
      for I in Spaces'Range loop
         while J = Figures(K) loop
            J := J + 1;
            K := K + 1;
         end loop;
         Spaces(I) := J;
         J := J + 1;
      end loop;
      return Spaces;
   end FFS;

   function FFS(P: Positive) return Positive is
      Spaces: Positive_Array := FFS(P);
   begin
      return Spaces(P);
   end FFS;

end Hofstadter_Figure_Figure;
