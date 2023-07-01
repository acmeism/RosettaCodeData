begin
   integer procedure ackermann(m,n);value m,n;integer m,n;
   ackermann:=if m=0 then n+1
         else if n=0 then ackermann(m-1,1)
                     else ackermann(m-1,ackermann(m,n-1));
   integer m,n;
   for m:=0 step 1 until 3 do begin
      for n:=0 step 1 until 6 do
         outinteger(1,ackermann(m,n));
      outstring(1,"\n")
   end
end
