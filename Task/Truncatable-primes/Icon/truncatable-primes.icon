procedure main(arglist)
   N := 0 < integer(\arglist[1]) | 1000000              # primes to generator 1 to ... (1M or 1st arglist)
   D := (0 < integer(\arglist[2]) | 10) / 2             # primes to display (10 or 2nd arglist)
   P := sieve(N)                                        # from sieve task (modified)
   write("There are ",*P," prime numbers in the range 1 to ",N)
   if *P <= 2*D then
      every writes( "Primes: "|!sort(P)||" "|"\n" )
   else
      every writes( "Primes: "|(L := sort(P))[1 to D]||" "|"... "|L[*L-D+1 to *L]||" "|"\n" )
   largesttruncateable(P)
end

procedure largesttruncateable(P)            #: find the largest left and right trucatable numbers in P
local ltp,rtp

   every x  := sort(P)[*P to 1 by -1] do    # largest to smallest
      if not find('0',x) then {
         /ltp  := islefttrunc(P,x)
         /rtp  := isrighttrunc(P,x)
         if \ltp & \rtp then break          # until both found
         }
   write("Largest left truncatable prime  = ", ltp)
   write("Largest right truncatable prime = ", rtp)
   return
end

procedure isrighttrunc(P,x) #: return integer x if x and all right truncations of x are in P or fails
if x = 0 | (member(P,x) & isrighttrunc(P,x / 10)) then return x
end

procedure islefttrunc(P,x) #: return integer x if x and all left truncations of x are in P or fails
if *x = 0 | ( (x := integer(x)) & member(P,x) & islefttrunc(P,x[2:0]) ) then return x
end
