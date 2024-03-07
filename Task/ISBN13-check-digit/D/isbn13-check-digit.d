import std.stdio;

bool isValidISBN13(string text) {
    int sum, i;
    foreach (c; text) {
        if ('0' <= c && c <= '9') {
            int value = c - '0';
            if (i % 2 == 0) {
                sum += value;
            } else {
                sum += 3 * value;
            }

            i++;
        }
    }
    return i == 13 && 0 == sum % 10;
}

unittest {
    assert(isValidISBN13("978-0596528126"));
    assert(!isValidISBN13("978-0596528120"));
    assert(isValidISBN13("978-1788399081"));
    assert(!isValidISBN13("978-1788399083"));
}
