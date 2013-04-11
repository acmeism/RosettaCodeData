import std.traits, std.algorithm;

bool isPalindrome1(C)(in C[] s) pure /*nothrow*/
if (isSomeChar!C) {
    auto s2 = s.dup; // not nothrow
    s2.reverse(); // works on Unicode too, not nothrow
    return s == s2;
}

void main() {
    alias isPalindrome1 pali;
    assert(pali(""));
    assert(pali("z"));
    assert(pali("aha"));
    assert(pali("sees"));
    assert(!pali("oofoe"));
    assert(pali("deified"));
    assert(!pali("Deified"));
    assert(pali("amanaplanacanalpanama"));
    assert(pali("ingirumimusnocteetconsumimurigni"));
    assert(pali("salÃ las"));
}
