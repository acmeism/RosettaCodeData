with Mat_Chain; use Mat_Chain;
with Ada.Text_IO; use Ada.Text_IO;

procedure chain_main is
   V1 : Vector := (5, 6, 3, 1);
   V2 : Vector := (1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2);
   V3 : Vector := (1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10);
begin
   Chain_Multiplication(V1);
   New_Line;
   Chain_Multiplication(V2);
   New_Line;
   Chain_Multiplication(V3);
end chain_main;
