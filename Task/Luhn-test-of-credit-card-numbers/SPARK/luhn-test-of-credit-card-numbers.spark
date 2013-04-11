with Spark_IO;
--# inherit Spark_IO;
--# main_program;
procedure Luhn
--# global in out Spark_IO.Outputs;
--# derives Spark_IO.Outputs from *;
is

   function Luhn_Test (Num : String) return Boolean
   --# pre  Num'Last <= 20;
   is
      Sum : Integer := 0;
      Od  : Boolean := True;
      Int : Integer;
      X   : Integer;
      OK  : Boolean := True;
   begin
      for P in reverse Integer range Num'Range loop
         Int := Character'Pos(Num(P)) - Character'Pos('0');
         if Int not in 0 .. 9 then
            OK := False;
            exit;
         end if;
         X := (((Int*2) mod 10) + (Int / 5));
         --# assert Num'Last - P in 0 .. 19
         --#   and  Sum in 0 .. (Num'Last - P) * 10
         --#   and  Int in 0 .. 9
         --#   and  X   in 0 .. 10;
         if Od then
            Sum := Sum + Int;
         else
            Sum := Sum + X;
         end if;
         Od := not Od;
      end loop;
      return OK and (Sum mod 10) = 0;
   end Luhn_Test;

   procedure Do_Test (Num : in     String)
   --# global in out Spark_IO.Outputs;
   --# derives Spark_IO.Outputs from *, Num;
   --# pre  Num'Last <= 20;
   is
   begin
      Spark_IO.Put_String(Spark_IO.Standard_Output, Num, 16);
      if Luhn_Test(Num) then
         Spark_IO.Put_String(Spark_IO.Standard_Output, " is valid.", 0);
      else
         Spark_IO.Put_String(Spark_IO.Standard_Output, " is not valid.", 0);
      end if;
      Spark_IO.New_Line(Spark_IO.Standard_Output, 1);
   end Do_Test;

begin
   Do_Test("49927398716");
   Do_Test("49927398717");
   Do_Test("1234567812345678");
   Do_Test("1234567812345670");
   Do_Test("123456781234567D");
end Luhn;
