-- perm.adb
-- print all permutations of 1 .. n
-- where n is given as a command line argument
-- to compile with GNAT : gnat make perm.adb
-- to call on command line : perm n
with Ada.Text_IO, Ada.Command_Line;

procedure Perm is
   use Ada.Text_IO, Ada.Command_Line;
   N : Integer;
begin
   if Argument_Count /= 1
   then
      Put_Line (Command_Name & " n (with n >= 1)");
      return;
   else
      N := Integer'Value (Argument (1));
   end if;
   declare
      subtype Element is Integer range 1 .. N;
      type Permutation is array (Element'Range) of Element;
      P : Permutation;
      Is_Last : Boolean := False;

      procedure Swap (A, B : in out Integer) is
         C : Integer := A;
      begin
         A := B;
         B := C;
      end;

      -- compute next permutation in lexicographic order
      -- iterative algorithm :
      --   find longest tail-decreasing sequence in p
      --   the elements from this tail cannot be permuted to get a new permutation, so
      --   reverse this tail, to start from an increaing sequence, and
      --   exchange the element x preceding the tail, with the minimum value in the tail,
      --   that is also greater than x
      procedure Next is
         I, J, K : Element;
      begin
         -- find longest tail decreasing sequence
         -- after the loop, this sequence is i+1 .. n,
         -- and the ith element will be exchanged later
         -- with some element of the tail
         Is_Last := True;
         I := N - 1;
         loop
            if P (I) < P (I+1)
            then
               Is_Last := False;
               exit;
            end if;

            -- next instruction will raise an exception if i = 1, so
            -- exit now (this is the last permutation)
            exit when I = 1;
            I := I - 1;
         end loop;

         -- if all the elements of the permutation are in
         -- decreasing order, this is the last one
         if Is_Last then
            return;
         end if;

         -- sort the tail, i.e. reverse it, since it is in decreasing order
         J := I + 1;
         K := N;
         while J < K loop
            Swap (P (J), P (K));
            J := J + 1;
            K := K - 1;
         end loop;

         -- find lowest element in the tail greater than the ith element
         J := N;
         while P (J) > P (I) loop
             J := J - 1;
         end loop;
         J := J + 1;

         -- exchange them
         -- this will give the next permutation in lexicographic order,
         -- since every element from ith to the last is minimum
         Swap (P (I), P (J));
      end next;

      procedure Print is
      begin
         for I in Element'Range loop
            Put (Integer'Image (P (I)));
         end loop;
         New_Line;
      end Print;

      -- initialize the permutation
      procedure Init is
      begin
         for I in Element'Range loop
            P (I) := I;
         end loop;
      end Init;

   begin
      Init;
      while not Is_Last loop
         Print;
         Next;
      end loop;
   end;

end Perm;
