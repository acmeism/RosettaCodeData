import std.stdio, std.string, std.conv, std.ascii, std.algorithm;

ulong ownCalcPass(in ulong password, in string nonce)
pure nothrow @safe @nogc
in {
    assert(nonce.representation.all!isDigit);
} body {
    enum ulong m_1        = 0x_FFFF_FFFF_UL;
    enum ulong m_8        = 0x_FFFF_FFF8_UL;
    enum ulong m_16       = 0x_FFFF_FFF0_UL;
    enum ulong m_128      = 0x_FFFF_FF80_UL;
    enum ulong m_16777216 = 0X_FF00_0000_UL;

    auto flag = true;
    ulong num1 = 0, num2 = 0;

    foreach (immutable char c; nonce) {
        num1 &= m_1;
        num2 &= m_1;

        switch (c) {
            case '0':
                num1 = num2;
                break;
            case '1':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 & m_128;
                num1 = num1 >> 7;
                num2 = num2 << 25;
                num1 = num1 + num2;
                break;
            case '2':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 & m_16;
                num1 = num1 >> 4;
                num2 = num2 << 28;
                num1 = num1 + num2;
                break;
            case '3':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 & m_8;
                num1 = num1 >> 3;
                num2 = num2 << 29;
                num1 = num1 + num2;
                break;
            case '4':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 << 1;
                num2 = num2 >> 31;
                num1 = num1 + num2;
                break;
            case '5':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 << 5;
                num2 = num2 >> 27;
                num1 = num1 + num2;
                break;
            case '6':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 << 12;
                num2 = num2 >> 20;
                num1 = num1 + num2;
                break;
            case '7':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 & 0xFF00UL;
                num1 = num1 + ((num2 & 0xFFUL) << 24);
                num1 = num1 + ((num2 & 0xFF0000UL) >> 16);
                num2 = (num2 & m_16777216) >> 8;
                num1 = num1 + num2;
                break;
            case '8':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = num2 & 0xFFFFUL;
                num1 = num1 << 16;
                num1 = num1 + (num2 >> 24);
                num2 = num2 & 0xFF0000UL;
                num2 = num2 >> 8;
                num1 = num1 + num2;
                break;
            case '9':
                if (flag)
                    num2 = password;
                flag = false;
                num1 = ~num2;
                break;
            default: // Impossible if contracts are active.
                assert(0, "Non-digit in nonce");
        }

        num2 = num1;
    }

    return num1 & m_1;
}

void ownTestCalcPass(in string sPassword, in string nonce, in ulong expected)
in {
    assert(sPassword.representation.all!isDigit);
    assert(nonce.representation.all!isDigit);
} body {
    immutable password = sPassword.to!ulong;
    immutable res = ownCalcPass(password, nonce);
    immutable m = format("%d %s %d %d", password, nonce, res, expected);
    writeln((res == expected) ? "PASS " : "FAIL ", m);
}

void main() {
    ownTestCalcPass("12345", "603356072", 25280520UL);
    ownTestCalcPass("12345", "410501656", 119537670UL);
}
