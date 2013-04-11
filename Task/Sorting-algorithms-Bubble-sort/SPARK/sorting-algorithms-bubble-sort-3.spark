package body Bubble
is
   procedure Sort (A : in out Arr)
   is
      Finished : Boolean;

      --  In_Position is a proof function with the definition:
      --    In_Position(A, A_Start, A_I, A_End)
      --      <->
      --    ((for all K in Integer range A_Start .. A_I - 1 =>
      --                (A(K) <= A(A_I)))
      --     and
      --     Sorted(A, A_I, A_End) .
      --
      --# function In_Position (A                  : Arr;
      --#                       A_Start, A_I, A_End : Integer) return Boolean;

      --  Swapped is a proof function with the definition:
      --    Swapped(A_In, A_Out, I1, I2)
      --      <->
      --    (A_Out = A_In[I1 => A_In(I2); I2 => A_In(I1)]).
      --
      --# function Swapped (A_In, A_Out : Arr;
      --#                   I1, I2      : Integer) return Boolean;

      procedure Swap (A  : in out Arr;
                      I1 : in     Integer;
                      I2 : in     Integer)
      --# derives A from *, I1, I2;
      --# pre  I1 in A'First .. A'Last
      --#  and I2 in A'First .. A'Last;
      --# post Swapped(A~, A, I1, I2);
      is
         Temp : Integer;
      begin
         Temp  := A(I2);
         A(I2) := A(I1);
         A(I1) := Temp;
      end Swap;
      pragma Inline (Swap);

   begin
      if A'Last > A'First then
         for I in reverse Integer range A'First + 1 .. A'Last loop
            Finished := True;
            for J in Integer range A'First .. I - 1 loop
               if A (J + 1) < A (J) then
                  Finished := False;
                  Swap (A, J, J + 1);
               end if;
               --# assert I% = I  --  I is unchanged by execution of the loop
               --#   and  (for all K in Integer range A'First .. J =>
               --#                    (A(K) <= A(J + 1)))
               --#   and  (I < A'Last -> In_Position(A, A'First, I + 1, A'Last))
               --#   and  (Finished -> Sorted(A, A'First, J + 1));
            end loop;
            exit when Finished;
            --# assert In_Position(A, A'First, I, A'Last);
         end loop;
      end if;
   end Sort;

end Bubble;
