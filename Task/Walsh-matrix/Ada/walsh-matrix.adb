pragma Ada_2022;

with Ada.Containers.Generic_Array_Sort;
with Ada.Text_IO;

procedure Walsh_Matrices is

   package IO renames Ada.Text_IO;

   --  SECTION
   --  Definition of a Walsh Matrix

   type Walsh_Value is (Red, Green);

   Opposite : constant array (Walsh_Value) of Walsh_Value :=
     [Red => Green, Green => Red];

   type Walsh_Matrix is
     array (Positive range <>, Positive range <>) of Walsh_Value;

   --  SECTION
   --  Sorting the matrix

   --  In order to avail ourselves of Ada's standard library,
   --  we define an auxiliary data
   --  that records the number of sign changes in a given row.
   --  We sort an array of **that** structure, then
   --  use that to sort the matrix.

   type Sort_Data_Record is record
      Row          : Positive;
      Sign_Changes : Natural;
   end record;

   type Sort_Data_Array is array (Positive range <>) of Sort_Data_Record;

   function "<" (Left, Right : Sort_Data_Record) return Boolean is
     (Left.Sign_Changes < Right.Sign_Changes);

   procedure Sort_By_Sequency is new Ada.Containers.Generic_Array_Sort
     (Index_Type => Positive, Element_Type => Sort_Data_Record,
      Array_Type => Sort_Data_Array);

   function Number_Of_Sign_Changes
     (Matrix : Walsh_Matrix; Row : Positive) return Natural
   is
      Result : Natural := 0;
   begin
      for Col in 2 .. Matrix'Last (2) loop
         Result :=
           @ + (if Matrix (Row, Col) = Matrix (Row, Col - 1) then 0 else 1);
      end loop;
      return Result;
   end Number_Of_Sign_Changes;

   procedure Sort_Matrix_By_Sequency (Matrix : in out Walsh_Matrix) is
      Sort_Data : Sort_Data_Array (Matrix'Range (1)) :=
         [for Ith in Matrix'Range (1) =>
            (Row => Ith,
             Sign_Changes => Number_Of_Sign_Changes (Matrix, Ith))];
      Temp : Walsh_Matrix (Matrix'Range (1), Matrix'Range (2));
   begin
      Sort_By_Sequency (Sort_Data);
      for Row in Matrix'Range (1) loop
         for Col in Matrix'Range (2) loop
            Temp (Row, Col) := Matrix (Sort_Data (Row).Row, Col);
         end loop;
      end loop;
      Matrix := Temp;
   end Sort_Matrix_By_Sequency;

   --  SECTION
   --  Displaying a Walsh Matrix

   type Display is (Number, Color);
   --  for the colors we imitate the Algol implementation

   Output : constant array (Walsh_Value, Display) of String (1 .. 2) :=
     [Red  => [Number => "-1", Color => " #"],
     Green => [Number => " 1", Color => " _"]];

   procedure Put (W : Walsh_Matrix; Kind : Display := Number) is
   begin
      for Row in W'Range (1) loop
         IO.Put ("( ");
         for Col in W'Range (2) loop
            IO.Put (Output (W (Row, Col), Kind) & " ");
         end loop;
         IO.Put_Line (" )");
      end loop;
   end Put;

   --  SECTION
   --  Creating a Walsh Matrix

   procedure Fill (W : in out Walsh_Matrix; Row, Col, Dim : Positive) is
   --  recursively fills a 2^Dim square submatrix of W,
   --  starting from the given row and column
   begin

      if Dim = 1 then
         W (Row, Col)         := Green;
         W (Row, Col + 1)     := Green;
         W (Row + 1, Col)     := Green;
         W (Row + 1, Col + 1) := Red;

      else
         Fill (W, Row, Col, Dim - 1);
         Fill (W, Row, Col + 2**(Dim - 1), Dim - 1);
         Fill (W, Row + 2**(Dim - 1), Col, Dim - 1);
         Fill (W, Row + 2**(Dim - 1), Col + 2**(Dim - 1), Dim - 1);
         for R in Row + 2**(Dim - 1) .. Row + 2**Dim - 1 loop
            for C in Col + 2**(Dim - 1) .. Col + 2**Dim - 1 loop
               W (R, C) := Opposite (@);
            end loop;
         end loop;

      end if;

   end Fill;

   function New_Matrix (Dimension : Positive) return Walsh_Matrix is
      Result : Walsh_Matrix (1 .. 2**Dimension, 1 .. 2**Dimension);
   begin
      Fill (Result, Result'First (1), Result'First (2), Dimension);
      return Result;
   end New_Matrix;

   --  SECTION
   --  a few values

   W_1 : Walsh_Matrix := New_Matrix (1);
   W_2 : Walsh_Matrix := New_Matrix (2);
   W_5 : Walsh_Matrix := New_Matrix (5);

begin
   Put (W_1, Color);
   IO.New_Line;
   Sort_Matrix_By_Sequency (W_1);
   Put (W_1, Color);
   IO.New_Line;
   Put (W_2, Color);
   IO.New_Line;
   Sort_Matrix_By_Sequency (W_2);
   Put (W_2, Color);
   IO.New_Line;
   Put (W_5, Color);
   IO.New_Line;
   Put (W_5);
   IO.New_Line;
   Sort_Matrix_By_Sequency (W_5);
   Put (W_5, Color);
   IO.New_Line;
end Walsh_Matrices;
