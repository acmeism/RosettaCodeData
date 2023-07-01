import std.stdio;

void main(string[] args) {
    writeln("CUSIP       Verdict");
    foreach(arg; args[1..$]) {
        writefln("%9s : %s", arg, isValidCusip(arg) ? "Valid" : "Invalid");
    }
}

class IllegalCharacterException : Exception {
    this(string msg) {
        super(msg);
    }
}

bool isValidCusip(string cusip) in {
    assert(cusip.length == 9, "Incorrect cusip length");
} body {
    try {
        auto check = cusipCheckDigit(cusip);
        return cusip[8] == ('0' + check);
    } catch (IllegalCharacterException e) {
        return false;
    }
}

unittest {
    // Oracle Corporation
    assertEquals(isValidCusip("68389X105"), true);

    // Oracle Corporation (invalid)
    assertEquals(isValidCusip("68389X106"), false);
}

int cusipCheckDigit(string cusip) in {
    assert(cusip.length == 9, "Incorrect cusip length");
} body {
    int sum;
    for (int i=0; i<8; ++i) {
        char c = cusip[i];
        int v;

        switch(c) {
            case '0': .. case '9':
                v = c - '0';
                break;
            case 'A': .. case 'Z':
                v = c - 'A' + 10;
                break;
            case '*':
                v = 36;
                break;
            case '@':
                v = 37;
                break;
            case '#':
                v = 38;
                break;
            default:
                throw new IllegalCharacterException("Saw character: " ~ c);
        }
        if (i%2 == 1) {
            v = 2 * v;
        }

        sum = sum + (v / 10) + (v % 10);
    }

   return (10 - (sum % 10)) % 10;
}

unittest {
    // Apple Incorporated
    assertEquals(cusipCheckDigit("037833100"), 0);

    // Cisco Systems
    assertEquals(cusipCheckDigit("17275R102"), 2);

    // Google Incorporated
    assertEquals(cusipCheckDigit("38259P508"), 8);

    // Microsoft Corporation
    assertEquals(cusipCheckDigit("594918104"), 4);

    // Oracle Corporation
    assertEquals(cusipCheckDigit("68389X105"), 5);
}

version(unittest) {
    void assertEquals(T)(T actual, T expected) {
        import core.exception;
        import std.conv;
        if (actual != expected) {
            throw new AssertError("Actual [" ~ to!string(actual) ~ "]; Expected [" ~ to!string(expected) ~ "]");
        }
    }
}

/// Invoke with `cusip 037833100 17275R102 38259P508 594918104 68389X106 68389X105`
