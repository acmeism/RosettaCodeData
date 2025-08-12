with Ada.Text_IO;

procedure Knapsack_Bounded is
   subtype Item_Name is String (1 .. 22);
   type Item_Weight is new Natural;
   type Item_Value is new Natural;
   type Item_Count is new Natural;
   type Item_Pool is record
      Name : Item_Name;
      Weight : Item_Weight;
      Value : Item_Value;
      Count : Item_Count;
   end record;
   type Item_Bag is array (1 .. 22) of Item_Pool;

   Candidates : constant Item_Bag :=
     (
       ("map                   ", 9, 150, 1),
       ("compass               ", 13, 35, 1),
       ("water                 ", 153, 200, 2),
       ("sandwich              ", 50, 60, 2),
       ("glucose               ", 15, 60, 2),
       ("tin                   ", 68, 45, 3),
       ("banana                ", 27, 60, 3),
       ("apple                 ", 39, 40, 3),
       ("cheese                ", 23, 30, 1),
       ("beer                  ", 52, 10, 3),
       ("suntan cream          ", 11, 70, 1),
       ("camera                ", 32, 30, 1),
       ("T-shirt               ", 24, 15, 2),
       ("trousers              ", 48, 10, 2),
       ("umbrella              ", 73, 40, 1),
       ("waterproof trousers   ", 42, 70, 1),
       ("waterproof overclothes", 43, 75, 1),
       ("note-case             ", 22, 80, 1),
       ("sunglasses            ", 7, 20, 1),
       ("towel                 ", 18, 12, 2),
       ("socks                 ", 4, 50, 1),
       ("book                  ", 30, 10, 2)
     );

   Capacity : constant Item_Weight := 400;
   Answer : Item_Bag;

   type Item_Table is
      array (Item_Bag'First - 1 .. Item_Bag'Last,
             Item_Weight'First .. Capacity) of Item_Value;

   Working_Table : Item_Table := (others => (others => 0));

   procedure Fill_Table is
      Item : Item_Pool;
      V, Max_Value : Item_Value;
      W : Item_Weight;
   begin
      for I in Candidates'Range loop
         Item := Candidates (I);

         for J in Working_Table'Range (2) loop
            Max_Value := Working_Table (I - 1, J);

            for K in 1 .. Item.Count loop
               V := Item_Value (K) * Item.Value;
               W := Item_Weight (K) * Item.Weight;

               if W <= J then
                  Max_Value := Item_Value'Max
                    (Max_Value, Working_Table (I - 1, J - W) + V);
               end if;
            end loop;

            Working_Table (I, J) := Max_Value;
         end loop;
      end loop;
   end Fill_Table;

   procedure Trace_Answer is
      Cap : Item_Weight := Capacity;
      Count : Item_Count;
      W, Weight : Item_Weight;
      V, Max_Value : Item_Value;
   begin
      for I in reverse Answer'Range loop
         Answer (I) := Candidates (I);
         Max_Value := Working_Table (I, Cap);
         Count := 0;
         Weight := 0;

         for J in 1 .. Candidates (I).Count loop
            W := Item_Weight (J) * Answer (I).Weight;
            V := Item_Value (J) * Answer (I).Value;
            if W <= Cap and then
               Max_Value = Working_Table (I - 1, Cap - W) + V then
               Weight := W;
               Count := J;
            end if;
         end loop;

         Cap := Cap - Weight;
         Answer (I).Count := Count;
      end loop;
   end Trace_Answer;

   procedure Show_Answer is
      package Count_IO is new Ada.Text_IO.Integer_IO (Item_Count);
      package Weight_IO is new Ada.Text_IO.Integer_IO (Item_Weight);
      package Value_IO is new Ada.Text_IO.Integer_IO (Item_Value);
      Item : Item_Pool;
      C, Total_Items : Item_Count := 0;
      W, Total_Weight : Item_Weight := 0;
      V, Total_Value : Item_Value := 0;
      Totals : String (Item_Name'Range) := "Totals                ";
   begin
      for I in Answer'Range loop
         Item := Answer (I);
         C := Item.Count;
         W := Item.Weight * Item_Weight (Item.Count);
         V := Item.Value * Item_Value (Item.Count);
         Total_Items := Total_Items + Item.Count;
         Total_Weight := Total_Weight + W;
         Total_Value := Total_Value + V;

         if C > 0 then
            Ada.Text_IO.Put (Item.Name);
            Count_IO.Put (C);
            Weight_IO.Put (W);
            Value_IO.Put (V);
            Ada.Text_IO.New_Line;
         end if;
      end loop;

      Ada.Text_IO.Put (Totals);
      Count_IO.Put (Total_Items);
      Weight_IO.Put (Total_Weight);
      Value_IO.Put (Total_Value);
      Ada.Text_IO.New_Line;
   end Show_Answer;

begin
   Fill_Table;
   Trace_Answer;
   Show_Answer;
end Knapsack_Bounded;
