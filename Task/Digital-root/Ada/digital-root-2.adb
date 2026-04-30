package body Generic_Root is

   procedure Compute_Root(N: Number;
                     Root, Persistence: out Number;
                     Base: Base_Type := 10) is

      function Digit_Sum(N: Number) return Number is
      begin
         if N < Number(Base) then
            return N;
         else
            return (N mod Number(Base)) & Digit_Sum(N / Number(Base));
         end if;
      end Digit_Sum;

   begin
      if N < Number(Base) then
         Root := N;
         Persistence := 0;
      else
         Compute_Root(Digit_Sum(N), Root, Persistence, Base);
         Persistence := Persistence + 1;
      end if;
   end Compute_Root;

end Generic_Root;
