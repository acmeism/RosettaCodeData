with Ada.Text_IO, Set_Cons;

procedure Set_Consolidation is

   type El_Type is (A, B, C, D, E, F, G, H, I, K);

   function Image(El: El_Type) return String is
   begin
      return El_Type'Image(El);
   end Image;

   package Helper is new Set_Cons(Element => El_Type, Image => Image);
   use Helper;

   function Consolidate(List: Set_Vec) return Set_Vec is
   begin
      for I in List'First .. List'Last - 1 loop
         for J in I+1 .. List'Last loop
            -- if List(I) and List(J) share an element
            -- then recursively consolidate
            --   (List(I) union List(J)) followed by List(K), K not in {I, J}
            if Nonempty_Intersection(List(I), List(J)) then
               return Consolidate
                 (Union(List(I), List(J))
                    & List(List'First .. I-1)
                    & List(I+1        .. J-1)
                    & List(J+1        .. List'Last));
            end if;
         end loop;
      end loop;
      return List;
   end Consolidate;

begin
   Ada.Text_IO.Put_Line(Image(Consolidate((A+B) & (C+D))));
   Ada.Text_IO.Put_Line(Image(Consolidate((A+B) & (B+D))));
   Ada.Text_IO.Put_Line(Image(Consolidate((A+B) & (C+D) & (D+B))));
   Ada.Text_IO.Put_Line
     (Image(Consolidate((H+I+K) & (A+B) & (C+D) & (D+B) & (F+G+H))));
end Set_Consolidation;
