with Ada.Text_IO; With Real_To_Rational;

procedure Convert_Decimal_To_Rational is

   type My_Real is new Long_Float; -- change this for another "Real" type

   package FIO is new Ada.Text_IO.Float_IO(My_Real);
   procedure R2R is new Real_To_Rational(My_Real);

   Nom, Denom: Integer;
   R: My_Real;

begin
   loop
      Ada.Text_IO.New_Line;
      FIO.Get(R);
      FIO.Put(R, Fore => 2, Aft => 9, Exp => 0);
      exit when R = 0.0;
      for I in 0 .. 4 loop
         R2R(R, 10**I, Nom, Denom);
         Ada.Text_IO.Put("  " & Integer'Image(Nom) &
                         " /" & Integer'Image(Denom));
      end loop;
   end loop;
end Convert_Decimal_To_Rational;
