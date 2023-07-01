"run() is the main function of this module."

shared void run() {

    function multiply(String|Integer|Integer[] top, String|Integer|Integer[] bottom, Integer base = 10) {

        function fromString(String s) =>
                s
                .filter(not(','.equals))
                .map((char) => Integer.parse(char.string))
                .narrow<Integer>()
                .sequence()
                .reversed;

        function toString(Integer[] ints) =>
                ""
                .join(ints.interpose(',', 3))
                .reversed
                .trimLeading((char) => char in "0,");

        function fromInteger(Integer int) => fromString(int.string);

        function convertArg(String|Integer|Integer[] arg) =>
                switch(arg)
                case (is String) fromString(arg)
                case (is Integer) fromInteger(arg)
                case (is Integer[]) arg;

        value a = convertArg(top);
        value b = convertArg(bottom);

        value p = a.size;
        value q = b.size;
        value product = Array.ofSize(p + q, 0);

        for (bIndex->bDigit in b.indexed) {
            variable value carry = 0;
            for (aIndex->aDigit in a.indexed) {
                assert (exists prodDigit = product[aIndex + bIndex]);
                value temp =  prodDigit + carry + aDigit * bDigit;
                carry = temp / base;
                product[aIndex + bIndex] = temp % base;
            }
            assert (exists lastDigit = product[bIndex + p]);
            product[bIndex + p] = lastDigit + carry;
        }

        return toString(product.sequence());
    }

    value twoToThe64th = "18,446,744,073,709,551,616";
    value expectedResult = "340,282,366,920,938,463,463,374,607,431,768,211,456";
    value result = multiply(twoToThe64th, twoToThe64th);

    print("The expected result is ``expectedResult``");
    print("The actual result is   ``result``");
    print("Do they match? ``expectedResult == result then "Yes!" else "No!"``");
}
