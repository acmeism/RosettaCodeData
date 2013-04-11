with Ada.Text_IO;
with Ada.Strings.Unbounded;

procedure Knapsack_01 is
   package US renames Ada.Strings.Unbounded;

   type Item is record
      Name   : US.Unbounded_String;
      Weight : Positive;
      Value  : Positive;
      Taken  : Boolean;
   end record;

   type Item_Array is array (Positive range <>) of Item;

   function Total_Weight (Items : Item_Array; Untaken : Boolean := False) return Natural is
      Sum : Natural := 0;
   begin
      for I in Items'Range loop
         if Untaken or else Items (I).Taken then
            Sum := Sum + Items (I).Weight;
         end if;
      end loop;
      return Sum;
   end Total_Weight;

   function Total_Value (Items : Item_Array; Untaken : Boolean := False) return Natural is
      Sum : Natural := 0;
   begin
      for I in Items'Range loop
         if Untaken or else Items (I).Taken then
            Sum := Sum + Items (I).Value;
         end if;
      end loop;
      return Sum;
   end Total_Value;

   function Max (Left, Right : Natural) return Natural is
   begin
      if Right > Left then
         return Right;
      else
         return Left;
      end if;
   end Max;

   procedure Solve_Knapsack_01 (Items : in out Item_Array;
                                Weight_Limit : Positive := 400) is
      type W_Array is array (0..Items'Length, 0..Weight_Limit) of Natural;
      W : W_Array := (others => (others => 0));
   begin
      -- fill W
      for I in Items'Range loop
         for J in 1 .. Weight_Limit loop
            if Items (I).Weight > J then
               W (I, J) := W (I - 1, J);
            else
               W (I, J) := Max (W (I - 1, J),
                                W (I - 1, J - Items (I).Weight) + Items (I).Value);
            end if;
         end loop;
      end loop;
      declare
         Rest : Natural := Weight_Limit;
      begin
         for I in reverse Items'Range loop
            if W (I, Rest) /= W (I - 1, Rest) then
               Items (I).Taken := True;
               Rest := Rest - Items (I).Weight;
            end if;
         end loop;
      end;
   end Solve_Knapsack_01;

   All_Items : Item_Array :=
     ( (US.To_Unbounded_String ("map"),                      9, 150, False),
       (US.To_Unbounded_String ("compass"),                 13,  35, False),
       (US.To_Unbounded_String ("water"),                  153, 200, False),
       (US.To_Unbounded_String ("sandwich"),                50, 160, False),
       (US.To_Unbounded_String ("glucose"),                 15,  60, False),
       (US.To_Unbounded_String ("tin"),                     68,  45, False),
       (US.To_Unbounded_String ("banana"),                  27,  60, False),
       (US.To_Unbounded_String ("apple"),                   39,  40, False),
       (US.To_Unbounded_String ("cheese"),                  23,  30, False),
       (US.To_Unbounded_String ("beer"),                    52,  10, False),
       (US.To_Unbounded_String ("suntan cream"),            11,  70, False),
       (US.To_Unbounded_String ("camera"),                  32,  30, False),
       (US.To_Unbounded_String ("t-shirt"),                 24,  15, False),
       (US.To_Unbounded_String ("trousers"),                48,  10, False),
       (US.To_Unbounded_String ("umbrella"),                73,  40, False),
       (US.To_Unbounded_String ("waterproof trousers"),     42,  70, False),
       (US.To_Unbounded_String ("waterproof overclothes"),  43,  75, False),
       (US.To_Unbounded_String ("note-case"),               22,  80, False),
       (US.To_Unbounded_String ("sunglasses"),               7,  20, False),
       (US.To_Unbounded_String ("towel"),                   18,  12, False),
       (US.To_Unbounded_String ("socks"),                    4,  50, False),
       (US.To_Unbounded_String ("book"),                    30,  10, False) );

begin
   Solve_Knapsack_01 (All_Items, 400);
   Ada.Text_IO.Put_Line ("Total Weight: " & Natural'Image (Total_Weight (All_Items)));
   Ada.Text_IO.Put_Line ("Total Value:  " & Natural'Image (Total_Value  (All_Items)));
   Ada.Text_IO.Put_Line ("Items:");
   for I in All_Items'Range loop
      if All_Items (I).Taken then
         Ada.Text_IO.Put_Line ("   " & US.To_String (All_Items (I).Name));
      end if;
   end loop;
end Knapsack_01;
