package body Prime_Numbers is
 -- auxiliary (internal) functions
   function First_Factor (N : Number; Start : Number) return Number is
      K    : Number  := Start;
   begin
      while ((N mod K) /= Zero) and then (N > (K*K))  loop
         K := K + One;
      end loop;
      if (N mod K) = Zero then
         return K;
      else
         return N;
      end if;
   end First_Factor;

   function Decompose (N : Number; Start : Number) return Number_List is
      F: Number := First_Factor(N, Start);
      M: Number := N / F;
   begin
      if M = One then -- F is the last factor
         return (1 => F);
      else
         return F & Decompose(M, Start);
      end if;
   end Decompose;

 -- functions visible from the outside
   function Decompose (N : Number) return Number_List is (Decompose(N, Two));
   function Is_Prime (N : Number) return Boolean is
      (N > One and then First_Factor(N, Two)=N);
end Prime_Numbers;
