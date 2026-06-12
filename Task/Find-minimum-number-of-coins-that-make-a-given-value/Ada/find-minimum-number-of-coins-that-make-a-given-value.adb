pragma Ada_2022;
with Ada.Text_IO;    use Ada.Text_IO;
procedure Find_Minimum_Coins is
   COINS      : constant array (1 .. 8) of Positive := [200, 100, 50, 20, 10, 5, 2, 1];
   CHANGE     : constant Positive := 988;
   Coins_Used : Natural := 0;
   Owing      : Natural := CHANGE;
   Count      : Natural;
begin
   Put_Line ("The minimum number of coins needed to make a value of" & CHANGE'Image & " is...");
   for Coin of COINS loop
      Count := Owing / Coin;
      if Count /= 0 then
         Coins_Used := @ + Count;
         Put_Line (Count'Image & " x" & Coin'Image);
         Owing := Owing mod Coin;
         exit when Owing = 0;
      end if;
   end loop;
   Put_Line ("A total of" & Coins_Used'Image & " coins.");
end Find_Minimum_Coins;
