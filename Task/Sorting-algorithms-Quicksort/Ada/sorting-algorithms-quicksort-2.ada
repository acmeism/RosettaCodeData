-----------------------------------------------------------------------
-- Generic Quick_Sort procedure
-----------------------------------------------------------------------

procedure Quick_Sort (A : in out Element_Array) is

   procedure Swap(Left, Right : Index) is
      Temp : Element := A (Left);
   begin
      A (Left) := A (Right);
      A (Right) := Temp;
   end Swap;

begin
   if A'Length > 1 then
   declare
      Pivot_Value : Element := A (A'First);
      Right       : Index := A'Last;
      Left        : Index := A'First;
   begin
       loop
          while Left < Right and not (Pivot_Value < A (Left)) loop
             Left := Index'Succ (Left);
          end loop;
          while Pivot_Value < A (Right) loop
             Right := Index'Pred (Right);
          end loop;
          exit when Right <= Left;
          Swap (Left, Right);
          Left := Index'Succ (Left);
          Right := Index'Pred (Right);
       end loop;
       if Right = A'Last then
          Right := Index'Pred (Right);
          Swap (A'First, A'Last);
       end if;
       if Left = A'First then
          Left := Index'Succ (Left);
       end if;
       Quick_Sort (A (A'First .. Right));
       Quick_Sort (A (Left .. A'Last));
   end;
   end if;
end Quick_Sort;
