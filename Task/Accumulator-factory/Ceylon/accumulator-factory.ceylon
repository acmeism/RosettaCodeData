shared void run() {
    Integer|Float accumulator
            (variable Integer|Float n)
            (Integer|Float i)
        =>  switch (i)
            case (is Integer)
                (n = n.plusInteger(i))
            case (is Float)
                (n = i + (switch(prev = n)
                          case (is Float) prev
                          case (is Integer) prev.float));

    value x = accumulator(1);
    print(x(5));
    print(accumulator(3));
    print(x(2.3));
}
