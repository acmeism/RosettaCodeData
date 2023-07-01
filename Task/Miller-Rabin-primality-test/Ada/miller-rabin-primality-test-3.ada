with Ada.Text_IO, Miller_Rabin;

procedure Mr_Tst is

   type Number is range 0 .. (2**48)-1;

   package Num_IO is new Ada.Text_IO.Integer_IO (Number);
   package Pos_IO is new Ada.Text_IO.Integer_IO (Positive);
   package MR     is new Miller_Rabin(Number); use MR;

   N : Number;
   K : Positive;

begin
   for I in Number(2) .. 1000 loop
      if Is_Prime (I) = Probably_Prime then
         Ada.Text_IO.Put (Number'Image (I));
      end if;
   end loop;
   Ada.Text_IO.Put_Line (".");

   Ada.Text_IO.Put ("Enter a Number: ");           Num_IO.Get (N);
   Ada.Text_IO.Put ("Enter the count of loops: "); Pos_IO.Get (K);
   Ada.Text_IO.Put_Line ("What is it? " & Result_Type'Image (Is_Prime(N, K)));
end MR_Tst;
