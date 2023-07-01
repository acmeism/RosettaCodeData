import std.traits;

bool isPalindrome2(C)(in C[] s) pure if (isSomeChar!C) {
    dchar[] dstr;
    foreach (dchar c; s) // not nothrow
        dstr ~= c;

    for (int i; i < dstr.length / 2; i++)
        if (dstr[i] != dstr[$ - i - 1])
            return false;
    return true;
}

void main() {
    alias isPalindrome2 pali;
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
