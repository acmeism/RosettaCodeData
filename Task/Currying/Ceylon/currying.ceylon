shared void run() {

    function divide(Integer x, Integer y) => x / y;

    value partsOf120 = curry(divide)(120);

    print("half of 120 is ``partsOf120(2)``
           a third is ``partsOf120(3)``
           and a quarter is ``partsOf120(4)``");
}
