Result(*Args) y1<Result,Args>(
        Result(*Args)(Result(*Args)) f)
        given Args satisfies Anything[] {

    class RecursiveFunction(o) {
        shared Result(*Args)(RecursiveFunction) o;
    }

    value r = RecursiveFunction((RecursiveFunction w)
        =>  f(flatten((Args args) => w.o(w)(*args))));

    return r.o(r);
}

value factorialY1 = y1((Integer(Integer) fact)(Integer x)
    =>  if (x > 1) then x * fact(x - 1) else 1);

value fibY1 = y1((Integer(Integer) fib)(Integer x)
    =>  if (x > 2) then fib(x - 1) + fib(x - 2) else 2);

print(factorialY1(10)); // 3628800
print(fibY1(10));       // 110
