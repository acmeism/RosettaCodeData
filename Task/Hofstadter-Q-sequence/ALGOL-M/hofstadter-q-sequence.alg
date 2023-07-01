begin
integer array Q[1:1000];
integer n;

Q[1] := Q[2] := 1;
for n := 3 step 1 until 1000 do
    Q[n] := Q[n-Q[n-1]] + Q[n-Q[n-2]];

write("The first 10 terms are:");
write("");
for n := 1 step 1 until 10 do writeon(Q[n]);

write("The 1000th term is:", Q[1000]);
end
