with Prisoners;   use Prisoners;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Wins : Win_Percentage;
   package Win_Percentage_IO is new Float_IO (Win_Percentage);
begin
   Wins := Play_Game (100_000, Optimal_Strategy'Access);
   Put ("Optimal Strategy = ");
   Win_Percentage_IO.Put (Wins, 2, 2, 0);
   Put ("%");
   New_Line;
   Wins := Play_Game (100_000, Random_Strategy'Access);
   Put ("Random Strategy = ");
   Win_Percentage_IO.Put (Wins, 2, 2, 0);
   Put ("%");
end Main;
