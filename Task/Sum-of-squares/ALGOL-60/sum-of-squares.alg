begin
   integer i;
   integer array A[ 1 : 5 ];
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
   comment initialie A;
   for i := 1 step 1 until 5 do A[i] := i;
   comment note the correspondence between the mathematical notation and the call to sum;
   outreal(1, sum (i, 1, 5, A[i] * A[i]))
end
