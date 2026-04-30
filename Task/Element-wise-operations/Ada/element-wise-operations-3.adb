package body Matrix_Scalar is

   function Func(Left: Matrix; Right: Num) return Matrix is
      Result: Matrix;
   begin
      for R in Rows loop
         for C in Cols loop
            Result(R,C) := F(Left(R,C), Right);
         end loop;
      end loop;
      return Result;
   end Func;

   function Image(M: Matrix) return String is

      function Img(R: Rows) return String is

         function I(C: Cols) return String is
            S: String := Image(M(R,C));
            L: Positive := S'First;
         begin
            while S(L) = ' ' loop
               L := L + 1;
            end loop;
            if C=Cols'Last then
               return S(L .. S'Last);
            else
               return S(L .. S'Last) & "," & I(Cols'Succ(C));
            end if;
         end I;

         Column: String := I(Cols'First);
      begin
         if R=Rows'Last then
            return "(" & Column & ")";
         else
            return "(" & Column & ")," & Img(Rows'Succ(R));
         end if;
      end Img;

   begin
      return("(" & Img(Rows'First) & ")");
   end Image;

end Matrix_Scalar;
