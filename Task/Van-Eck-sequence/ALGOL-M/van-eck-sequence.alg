begin
integer array eck[1:1000];
integer i, j;

for i := 1 step 1 until 1000 do
    eck[i] := 0;

for i := 1 step 1 until 999 do
begin
    j := i - 1;
    while j > 0 and eck[i] <> eck[j] do
        j := j - 1;
    if j <> 0 then
        eck[i+1] := i - j;
end;

for i := 1 step 1 until 10 do
    writeon(eck[i]);
write("");
for i := 991 step 1 until 1000 do
    writeon(eck[i]);

end
