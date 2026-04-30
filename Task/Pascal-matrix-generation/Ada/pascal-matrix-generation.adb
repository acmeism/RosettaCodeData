-- for I/O
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

-- for estimating the maximum width of a column
with Ada.Numerics.Generic_Elementary_Functions;

procedure PascalMatrix is

  type Matrix is array (Positive range <>, Positive range <>) of Natural;

  -- instantiate Generic_Elementary_Functions for Float type
  package Math is new Ada.Numerics.Generic_Elementary_Functions(Float_Type => Float);
  use Math;

  procedure Print(m: in Matrix) is
    -- determine the maximum width of a column
    w: Float := Log(Float(m'Length(1)**(m'Length(1)/2)), 10.0);
    width: Positive := Natural(Float'Ceiling(w)) + 1;
    begin
      for i in m'First(1)..m'Last(1) loop
        Put("( ");
        for j in m'First(2)..m'Last(2) loop
          Put(m(i,j), width);
        end loop;
        Put(" )"); New_Line(1);
      end loop;
    end Print;

  function Upper_Triangular(n: in Positive) return Matrix is
    result: Matrix(1..n, 1..n) := (
                                    1 => ( others => 1 ),
                                    others => ( others => 0 )
                                  );
    begin
      for i in 2..n loop
        result(i,i) := 1;
        for j in i+1..n loop
          result(i,j) := result(i,j-1) + result(i-1,j-1);
        end loop;
      end loop;
      return result;
    end Upper_Triangular;

  function Lower_Triangular(n: in Positive) return Matrix is
    result: Matrix(1..n, 1..n) := (
                                    others => ( 1 => 1, others => 0 )
                                  );
    begin
      for i in 2..n loop
        result(i,i) := 1;
        for j in i+1..n loop
          result(j,i) := result(j-1,i) + result(j-1,i-1);
        end loop;
      end loop;
      return result;
    end Lower_Triangular;

  function Symmetric(n: in Positive) return Matrix is
    result: Matrix(1..n, 1..n) := (
                                   1 => ( others => 1 ),
                                   others => ( 1 => 1, others => 0 )
                                  );
    begin
      for i in 2..n loop
        for j in 2..n loop
          result(i,j) := result(i,j-1) + result(i-1,j);
        end loop;
      end loop;
      return result;
    end Symmetric;

  n: Positive;

  begin
    Put("What dimension Pascal matrix would you like? ");
    Get(n);
    Put("Upper triangular:"); New_Line(1);
    Print(Upper_Triangular(n));
    Put("Lower triangular:"); New_Line(1);
    Print(Lower_Triangular(n));
    Put("Symmetric:"); New_Line(1);
    Print(Symmetric(n));
  end PascalMatrix;
