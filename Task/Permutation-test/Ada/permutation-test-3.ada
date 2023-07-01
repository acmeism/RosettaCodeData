package body Iterate_Subsets is

   function First return Subset is
      S: Subset;
   begin
      for I in S'Range loop
         S(I) := I;
      end loop;
      return S;
   end First;

   procedure Next(S: in out Subset) is
      I: Natural := S'Last;
   begin
      if S(I) < Index'Last then
         S(I) := S(I) + 1;
      else
         while S(I-1)+1 = S(I) loop
            I := I - 1;
         end loop;
         S(I-1) := S(I-1) + 1;
         for J in I .. S'Last loop
            S(J) := S(J-1) + 1;
         end loop;
      end if;
      return;
   end Next;

   function Last(S: Subset) return Boolean is
   begin
      return S(S'First) = Index'Last-S'Length+1;
   end Last;

end Iterate_Subsets;
