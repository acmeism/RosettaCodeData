import ceylon.whole {
    wholeNumber,
    two
}

shared void run() {

    value five = wholeNumber(5);
    value four = wholeNumber(4);
    value three = wholeNumber(3);

    value bigNumber = five ^ four ^ three ^ two;

    value firstTwenty = "62060698786608744707";
    value lastTwenty =  "92256259918212890625";
    value bigString = bigNumber.string;

    "The number must start with ``firstTwenty`` and end with ``lastTwenty``"
    assert(bigString.startsWith(firstTwenty), bigString.endsWith(lastTwenty));

    value bigSize = bigString.size;
    print("The first twenty digits are ``bigString[...19]``");
    print("The last twenty digits are ``bigString[(bigSize - 20)...]``");
    print("The number of digits in 5^4^3^2 is ``bigSize``");
}
