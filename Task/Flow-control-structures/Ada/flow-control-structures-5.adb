select
   delay 10.0;
   Put_Line ("Cannot finish this in 10s");
then abort
   -- do some lengthy calculation
   ...
end select;
