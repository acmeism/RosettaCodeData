data _null_;
  do i=1 to 100;
    if mod(i,15)=0 then put "FizzBuzz";
    else if mod(i,5)=0 then put "Buzz";
    else if mod(i,3)=0 then put "Fizz";
    else put i;
  end;
run;
