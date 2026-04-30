package body Matrices is
   procedure Swap_Rows (From : in out Matrix; First, Second : in Positive) is
      Temporary : Element_Type;
   begin
      for Col in From'Range (2) loop
         Temporary          := From (First, Col);
         From (First, Col)  := From (Second, Col);
         From (Second, Col) := Temporary;
      end loop;
   end Swap_Rows;

   procedure Divide_Row
     (From    : in out Matrix;
      Row     : in Positive;
      Divisor : in Element_Type)
   is
   begin
      for Col in From'Range (2) loop
         From (Row, Col) := From (Row, Col) / Divisor;
      end loop;
   end Divide_Row;

   procedure Subtract_Rows
     (From                : in out Matrix;
      Subtrahend, Minuend : in Positive;
      Factor              : in Element_Type)
   is
   begin
      for Col in From'Range (2) loop
         From (Minuend, Col) := From (Minuend, Col) -
                                From (Subtrahend, Col) * Factor;
      end loop;
   end Subtract_Rows;

   function Reduced_Row_Echelon_form (Source : Matrix) return Matrix is
      Result : Matrix   := Source;
      Lead   : Positive := Result'First (2);
      I      : Positive;
   begin
      Rows : for Row in Result'Range (1) loop
         exit Rows when Lead > Result'Last (2);
         I := Row;
         while Result (I, Lead) = Zero loop
            I := I + 1;
            if I = Result'Last (1) then
               I    := Row;
               Lead := Lead + 1;
               exit Rows when Lead = Result'Last (2);
            end if;
         end loop;
         if I /= Row then
            Swap_Rows (From => Result, First => I, Second => Row);
         end if;
         Divide_Row
           (From    => Result,
            Row     => Row,
            Divisor => Result (Row, Lead));
         for Other_Row in Result'Range (1) loop
            if Other_Row /= Row then
               Subtract_Rows
                 (From       => Result,
                  Subtrahend => Row,
                  Minuend    => Other_Row,
                  Factor     => Result (Other_Row, Lead));
            end if;
         end loop;
         Lead := Lead + 1;
      end loop Rows;
      return Result;
   end Reduced_Row_Echelon_form;
end Matrices;
