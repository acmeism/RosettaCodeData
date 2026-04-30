with Ada.Text_IO; use Ada.Text_IO;

procedure Rumps_example is

   type Short is digits(8);
   type Long  is digits(16);

   A: constant := 77617.0;
   B: constant := 33096.0;
   C: constant := 333.75*B**6 + A**2*(11.0*A**2*B**2 - B**6 - 121.0*B**4 - 2.0) + 5.5*B**8 + A/(2.0*B);

   package LIO is new Float_IO(Long);
   package SIO is new Float_IO(Short);
begin
   Put("Rump's Example, Short: ");
   SIO.Put(C, Fore => 1, Aft => 8, Exp => 0);  New_Line;
   Put("Rump's Example, Long:  ");
   LIO.Put(C, Fore => 1, Aft => 16, Exp => 0); New_Line;
end Rumps_example;
