#lang algol60
begin
   integer i;
   real procedure sum (i, lo, hi, term);
      value lo, hi;
      integer i, lo, hi;
      real term;
      comment term is passed by-name, and so is i;
   begin
      real temp;
      temp := 0;
      for i := lo step 1 until hi do
         temp := temp + term;
      sum := temp
   end;
   comment note the correspondence between the mathematical notation and the call to sum;
   printnln (sum (i, 1, 100, 1/i))
end
