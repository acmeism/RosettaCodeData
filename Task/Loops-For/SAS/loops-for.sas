data _null_;
length a $5;
do n=1 to 5;
  a="*";
  do i=2 to n;
    a=trim(a) !! "*";
  end;
  put a;
end;
run;

/* Possible without the inner loop. Notice TRIM is replaced with STRIP,
otherwise there is a blank space on the left */

data _null_;
length a $5;
do n=1 to 5;
  a=strip(a) !! "*";
  put a;
end;
run;
