options cmplib=work.f;

proc fcmp outlib=work.f.p;
    function fib(n);
    if n = 0 or n = 1
        then return(1);
        else return(fib(n - 2) + fib(n - 1));
    endsub;
run;

data _null_;
    x = fib(5);
    put 'fib(5) = ' x;
run;
