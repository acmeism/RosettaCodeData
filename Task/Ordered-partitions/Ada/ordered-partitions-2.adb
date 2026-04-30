package body Partitions is
   -- compare number sets (not provided)
   function "<" (Left, Right : Number_Sets.Set) return Boolean is
      use type Ada.Containers.Count_Type;
      use Number_Sets;
      Left_Pos  : Cursor := Left.First;
      Right_Pos : Cursor := Right.First;
   begin
      -- compare each element, until one or both lists finishes
      while Left_Pos /= No_Element and then Right_Pos /= No_Element loop
         -- compare elements
         if Element (Left_Pos) < Element (Right_Pos) then
            return True;
         elsif Element (Left_Pos) > Element (Right_Pos) then
            return False;
         end if;
         -- increase iterator
         Next (Left_Pos);
         Next (Right_Pos);
      end loop;
      -- Right is longer
      if Right_Pos /= No_Element then
         return True;
      else
         -- Left is longer, or Left and Right are identical.
         return False;
      end if;
   end "<";
   -- compare two Partitions
   function "<" (Left, Right : Partition) return Boolean is
      use type Ada.Containers.Count_Type;
      use type Number_Sets.Set;
   begin
      -- check length
      if Left'Length < Right'Length then
         return True;
      elsif Left'Length > Right'Length then
         return False;
      end if;
      -- same length
      if Left'Length > 0 then
         for I in Left'Range loop
            if Left (I) < Right (I) then
               return True;
            elsif Left (I) /= Right (I) then
               return False;
            end if;
         end loop;
      end if;
      -- length = 0 are always smallest
      return False;
   end "<";
   -- create partitions (as the task describes)
   function Create_Partitions (Args : Arguments) return Partition_Sets.Set is
      -- permutations needed
      type Permutation is array (Positive range <>) of Natural;
      -- exception to be thrown after last permutation reached
      No_More_Permutations : exception;
      -- get initial permutation (ordered small->big)
      function Initial_Permutation (Max : Natural) return Permutation is
         Result : Permutation (1 .. Max);
      begin
         for I in 1 .. Max loop
            Result (I) := I;
         end loop;
         return Result;
      end Initial_Permutation;
      -- get next permutation
      function Next_Permutation (Current : Permutation) return Permutation is
         K      : Natural     := Current'Last - 1;
         L      : Positive    := Current'Last;
         Result : Permutation := Current;
      begin
         -- 1. Find the largest index k such that a[k] < a[k + 1].
         while K /= 0 and then Current (K) > Current (K + 1) loop
            K := K - 1;
         end loop;
         -- If no such index exists, the permutation is the last permutation.
         if K = 0 then
            raise No_More_Permutations;
         end if;
         -- 2. Find the largest index l such that a[k] < a[l].
         -- Since k + 1 is such an index, l is well defined
         -- and satisfies k < l.
         while Current (K) > Current (L) loop
            L := L - 1;
         end loop;
         -- 3. Swap a[k] with a[l].
         Result (K) := Current (L);
         Result (L) := Current (K);
         -- 4. Reverse the sequence from a[k + 1] up to and including the
         -- final element a[n].
         for I in 1 .. (Result'Last - K) / 2 loop
            declare
               Temp : constant Natural := Result (K + I);
            begin
               Result (K + I)               := Result (Result'Last - I + 1);
               Result (Result'Last - I + 1) := Temp;
            end;
         end loop;
         return Result;
      end Next_Permutation;
      Result : Partition_Sets.Set;
      Sum    : Natural := 0;
   begin
      -- get number of elements
      for I in Args'Range loop
         Sum := Sum + Args (I);
      end loop;
      declare
      -- initial permutation
         Current_Permutation : Permutation := Initial_Permutation (Sum);
      begin
         -- loop through permutations
         loop
         -- create Partition (same count of Number_Sets.Set as Args)
            declare
               Item              : Natural := Current_Permutation'First;
               Current_Partition : Partition (Args'Range);
            begin
               -- loop each partition
               for I in Args'Range loop
                  -- fill in the number of elements requested
                  for J in 1 .. Args (I) loop
                     Current_Partition (I).Insert
                       (New_Item => Current_Permutation (Item));
                     Item := Item + 1;
                  end loop;
               end loop;
               -- insert partition into result set
               Result.Insert (New_Item => Current_Partition);
            exception
               when Constraint_Error =>
                  -- partition was already inserted, ignore it.
                  -- this happens when one of the args > 1.
                  null;
            end;
            -- create next permutation
            Current_Permutation := Next_Permutation (Current_Permutation);
         end loop;
      exception
         when No_More_Permutations =>
            -- no more permutations, we are finished
            null;
      end;
      return Result;
   end Create_Partitions;
end Partitions;
