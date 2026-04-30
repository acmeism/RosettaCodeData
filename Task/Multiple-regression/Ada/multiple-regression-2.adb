package body Matrices is
   function "*" (Left, Right : Matrix) return Matrix is
      Result : Matrix (Left'Range (1), Right'Range (2)) :=
        (others => (others => Zero));
   begin
      if Left'Length (2) /= Right'Length (1) then
         raise Size_Mismatch;
      end if;
      for I in Result'Range (1) loop
         for K in Result'Range (2) loop
            for J in Left'Range (2) loop
               Result (I, K) := Result (I, K) + Left (I, J) * Right (J, K);
            end loop;
         end loop;
      end loop;
      return Result;
   end "*";

   function Invert (Source : Matrix) return Matrix is
      Expanded : Matrix (Source'Range (1),
         Source'First (2) .. Source'Last (2) * 2);
      Result   : Matrix (Source'Range (1), Source'Range (2));
   begin
      -- Matrix has to be square.
      if Source'Length (1) /= Source'Length (2) then
         raise Not_Square_Matrix;
      end if;
      -- Copy Source into Expanded matrix and attach identity matrix to right
      for Row in Source'Range (1) loop
         for Col in Source'Range (2) loop
            Expanded (Row, Col)                    := Source (Row, Col);
            Expanded (Row, Source'Last (2) + Col)  := Zero;
         end loop;
         Expanded (Row, Source'Last (2) + Row)  := One;
      end loop;
      Expanded := Reduced_Row_Echelon_Form (Source => Expanded);
      -- Copy right side to Result (= inverted Source)
      for Row in Result'Range (1) loop
         for Col in Result'Range (2) loop
            Result (Row, Col) := Expanded (Row, Source'Last (2) + Col);
         end loop;
      end loop;
      return Result;
   end Invert;

   function Reduced_Row_Echelon_Form (Source : Matrix) return Matrix is
      procedure Divide_Row
        (From    : in out Matrix;
         Row     : Positive;
         Divisor : Element_Type)
      is
      begin
         for Col in From'Range (2) loop
            From (Row, Col) := From (Row, Col) / Divisor;
         end loop;
      end Divide_Row;

      procedure Subtract_Rows
        (From                : in out Matrix;
         Subtrahend, Minuend : Positive;
         Factor              : Element_Type)
      is
      begin
         for Col in From'Range (2) loop
            From (Minuend, Col) := From (Minuend, Col) -
                                   From (Subtrahend, Col) * Factor;
         end loop;
      end Subtract_Rows;

      procedure Swap_Rows (From : in out Matrix; First, Second : Positive) is
         Temporary : Element_Type;
      begin
         for Col in From'Range (2) loop
            Temporary          := From (First, Col);
            From (First, Col)  := From (Second, Col);
            From (Second, Col) := Temporary;
         end loop;
      end Swap_Rows;

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
   end Reduced_Row_Echelon_Form;

   function Regression_Coefficients
     (Source     : Vector;
      Regressors : Matrix)
      return       Vector
   is
      Result : Matrix (Regressors'Range (2), 1 .. 1);
   begin
      if Source'Length /= Regressors'Length (1) then
         raise Size_Mismatch;
      end if;
      declare
         Regressors_T : constant Matrix := Transpose (Regressors);
      begin
         Result := Invert (Regressors_T * Regressors) *
                   Regressors_T *
                   To_Matrix (Source);
      end;
      return To_Row_Vector (Source => Result);
   end Regression_Coefficients;

   function To_Column_Vector
     (Source : Matrix;
      Row    : Positive := 1)
      return   Vector
   is
      Result : Vector (Source'Range (2));
   begin
      for Column in Result'Range loop
         Result (Column) := Source (Row, Column);
      end loop;
      return Result;
   end To_Column_Vector;

   function To_Matrix
     (Source        : Vector;
      Column_Vector : Boolean := True)
      return          Matrix
   is
      Result : Matrix (1 .. 1, Source'Range);
   begin
      for Column in Source'Range loop
         Result (1, Column) := Source (Column);
      end loop;
      if Column_Vector then
         return Transpose (Result);
      else
         return Result;
      end if;
   end To_Matrix;

   function To_Row_Vector
     (Source : Matrix;
      Column : Positive := 1)
      return   Vector
   is
      Result : Vector (Source'Range (1));
   begin
      for Row in Result'Range loop
         Result (Row) := Source (Row, Column);
      end loop;
      return Result;
   end To_Row_Vector;

   function Transpose (Source : Matrix) return Matrix is
      Result : Matrix (Source'Range (2), Source'Range (1));
   begin
      for Row in Result'Range (1) loop
         for Column in Result'Range (2) loop
            Result (Row, Column) := Source (Column, Row);
         end loop;
      end loop;
      return Result;
   end Transpose;
end Matrices;
