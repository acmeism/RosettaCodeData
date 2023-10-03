begin
   integer procedure lagarias ( integer value n ) ; % Lagarias arithmetic derivative %
           if n < 0
           then -lagarias (-n)
           else if n = 0 or n = 1
           then 0
           else begin
                integer f, q;
                integer procedure smallPf ( integer value j, k ) ; % Smallest prime factor %
                    if j rem k = 0 then k else smallPf (j, k + 1);
                f := smallPf (n, 2); q := n div f;
                if q = 1
                then 1
                else q * lagarias (f) + f * lagarias (q)
           end lagarias ;

   for n := -99 until 100 do begin
       writeon( i_w := 6, s_w := 0, " ", lagarias (n) );
       if n rem 10 = 0 then write()
   end for_n
end.
