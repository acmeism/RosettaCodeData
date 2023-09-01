begin

integer first, second;

write("Two Dimensional Array Exercise");
write("Length of first dimension:");
read(first);
write("Length of second dimension:");
read(second);

begin % we need to start a new block %
   integer array test[1:first, 1:second];
   test[1,1] := 99;
   write("Stored value at 1,1 =",test[1,1]);
end; % array is now out of scope %

end
