with Ada.Text_IO; use Ada.Text_IO;

procedure Show_Cocktail_Sort is
   generic
      type T is private;
   procedure Swap (A, B : in out T);

   procedure Swap (A, B : in out T) is
      Tmp : constant T := A;
   begin
      A := B;
      B := Tmp;
   end Swap;

   generic
      type T is private;
      type Index is (<>);
      type T_Array_Type is array (Index range <>) of T;
      with function ">" (Left, Right : T) return Boolean;
   procedure Cocktail_Sort (T_Array : in out T_Array_Type);

   procedure Cocktail_Sort (T_Array : in out T_Array_Type) is
      procedure Swap_T is new Swap (T => T);
      Low_Index      : Index := T_Array'First;
      High_Index     : Index := Index'Pred (T_Array'Last);
      New_Low_Index  : Index;
      New_High_Index : Index;
   begin
      while Low_Index <= High_Index loop
         New_Low_Index := High_Index;
         New_High_Index := Low_Index;
         for I in Low_Index .. High_Index loop
            if T_Array (I) > T_Array (Index'Succ (I)) then
               Swap_T (T_Array (I), T_Array (Index'Succ (I)));
               New_High_Index := I;
            end if;
         end loop;
         High_Index := Index'Pred (New_High_Index);
         for I in reverse Low_Index .. High_Index loop
            if T_Array (I) > T_Array (Index'Succ (I)) then
               Swap_T (T_Array (I), T_Array (Index'Succ (I)));
               New_Low_Index := I;
            end if;
         end loop;
         Low_Index := Index'Succ (New_Low_Index);
      end loop;
   end Cocktail_Sort;

   subtype Index is Positive range 1 .. 10;
   type Positive_Array_Type is array (Positive range <>) of Positive;
   Positive_Array : Positive_Array_Type (Index) :=
     (6, 10, 3, 1, 5, 8, 4, 9, 2, 7);

   procedure Print_Positive_Array is
   begin
      Put ("Example array:");
      for I in Index loop
         Put (Positive'Image (Positive_Array (I)));
      end loop;
      New_Line;
   end Print_Positive_Array;

   procedure Sort_Positive_Array is new
     Cocktail_Sort
       (T            => Positive,
        Index        => Positive,
        T_Array_Type => Positive_Array_Type,
        ">"          => Standard.">");
begin
   Print_Positive_Array;
   Sort_Positive_Array (Positive_Array);
   Put_Line ("Sorted");
   Print_Positive_Array;
end Show_Cocktail_Sort;
