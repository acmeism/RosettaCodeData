import std.stdio;

void main() {
    import std.algorithm : each, max, reduce, sort;
    import std.range : take;

    Stat stat = new Stat();

    comment("Show all solutions that sum to 100");
    immutable givenSum = 100;
    print(givenSum);

    comment("Show the sum that has the maximum number of solutions");
    const int maxCount = reduce!max(stat.sumCount.keys);
    int maxSum;
    foreach(key, entry; stat.sumCount[maxCount]) {
        if (key >= 0) {
            maxSum = key;
            break;
        }
    }
    writeln(maxSum, " has ", maxCount, " solutions");

    comment("Show the lowest positive number that can't be expressed");
    int value = 0;
    while (value in stat.countSum) {
        value++;
    }
    writeln(value);

    comment("Show the ten highest numbers that can be expressed");
    const int n = stat.countSum.keys.length;
    auto sums = stat.countSum.keys;
    sums.sort!"a>b"
        .take(10)
        .each!print;
}

void comment(string commentString) {
    writeln();
    writeln(commentString);
    writeln();
}

void print(int givenSum) {
    Expression expression = new Expression();
    for (int i=0; i<Expression.NUMBER_OF_EXPRESSIONS; i++, expression.next()) {
        if (expression.toInt() == givenSum) {
            expression.print();
        }
    }
}

class Expression {
    private enum NUMBER_OF_DIGITS = 9;
    private enum ADD = 0;
    private enum SUB = 1;
    private enum JOIN = 2;

    enum NUMBER_OF_EXPRESSIONS = 2 * 3 * 3 * 3 * 3 * 3 * 3 * 3 * 3;
    byte[NUMBER_OF_DIGITS] code;

    Expression next() {
        for (int i=0; i<NUMBER_OF_DIGITS; i++) {
            if (++code[i] > JOIN) {
                code[i] = ADD;
            } else {
                break;
            }
        }
        return this;
    }

    int toInt() {
        int value = 0;
        int number = 0;
        int sign = (+1);
        for (int digit=1; digit<=9; digit++) {
            switch (code[NUMBER_OF_DIGITS - digit]) {
                case ADD:
                    value += sign * number;
                    number = digit;
                    sign = (+1);
                    break;
                case SUB:
                    value += sign * number;
                    number = digit;
                    sign = (-1);
                    break;
                case JOIN:
                    number = 10 * number + digit;
                    break;
                default:
                    assert(false);
            }
        }
        return value + sign * number;
    }

    void toString(scope void delegate(const(char)[]) sink) const {
        import std.conv : to;
        import std.format : FormatSpec, formatValue;
        import std.range : put;

        auto fmt = FormatSpec!char("s");
        for (int digit=1; digit<=NUMBER_OF_DIGITS; digit++) {
            switch (code[NUMBER_OF_DIGITS - digit]) {
                case ADD:
                    if (digit > 1) {
                        put(sink, '+');
                    }
                    break;
                case SUB:
                    put(sink, '-');
                    break;
                default:
                    break;
            }
            formatValue(sink, digit, fmt);
        }
    }

    void print() {
        print(stdout);
    }

    void print(File printStream) {
        printStream.writefln("%9d = %s", toInt(), this);
    }
}

class Stat {
    int[int] countSum;
    bool[int][int] sumCount;

    this() {
        Expression expression = new Expression();
        for (int i=0; i<Expression.NUMBER_OF_EXPRESSIONS; i++, expression.next()) {
            int sum = expression.toInt();
            countSum[sum]++;
        }
        foreach (key, entry; countSum) {
            bool[int] set;
            if (entry in sumCount) {
                set = sumCount[entry];
            } else {
                set.clear();
            }
            set[key] = true;
            sumCount[entry] = set;
        }
    }
}
