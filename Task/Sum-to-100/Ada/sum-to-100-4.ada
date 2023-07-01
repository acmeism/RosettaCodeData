with Sum_To, Ada.Containers.Ordered_Maps, Ada.Text_IO;
use Ada.Text_IO;

procedure Three_Others is

   package Num_Maps is new Ada.Containers.Ordered_Maps
     (Key_Type => Integer, Element_Type => Positive);
   use Num_Maps;

   Map: Num_Maps.Map;
   -- global Map stores how often a sum did occur

   procedure Insert_Solution(S: String; Sum: Integer) is
      -- inserts a solution into global Map
      use Num_Maps;
      -- use type Num_Maps.Cursor;
      Position: Cursor := Map.Find(Sum);
   begin
      if Position = No_Element then -- first solutions for Sum
	 Map.Insert(Key => Sum, New_Item => 1); -- counter is 1
      else -- increase counter for Sum
	 Map.Replace_Element(Position => Position,
			     New_Item => (Element(Position))+1);
      end if;
   end Insert_Solution;

   procedure Generate_Map is new Sum_To.Eval(Insert_Solution);

   Current: Cursor; -- Points into Map
   Sum: Integer;    -- current Sum of interest
   Max: Natural;
begin
   Generate_Map;

   -- find Sum >= 0  with maximum number of solutions
   Max := 0; -- number of solutions for Sum (so far, none)
   Current := Map.Ceiling(0); -- first element in Map with Sum >= 0
   while Has_Element(Current) loop
      if Element(Current) > Max then
	 Max := Element(Current); -- the maximum of solutions, so far
	 Sum := Key(Current);     -- the Sum with Max solutions
      end if;
      Next(Current);
   end loop;
   Put_Line("Most frequent result:" & Integer'Image(Sum));
   Put_Line("Frequency of" & Integer'Image(Sum) & ":" &
	      Integer'Image(Max));
   New_Line;

   -- find smallest Sum >= 0 with no solution
   Sum := 0;
   while Map.Find(Sum) /= No_Element loop
      Sum := Sum + 1;
   end loop;
   Put_Line("Smallest nonnegative impossible sum:" & Integer'Image(Sum));
   New_Line;

   -- find ten highest numbers with a solution
   Current := Map.Last; -- highest element in Map with a solution
   Put_Line("Highest sum:" & Integer'Image(Key(Current)));
   Put("Next nine:");
   for I in 1 .. 9 loop -- 9 steps backward
      Previous(Current);
      Put(Integer'Image(Key(Current)));
   end loop;
   New_Line;
end Three_others;
