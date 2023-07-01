bool isPalindrome4(in string str) pure nothrow {
    if (str.length == 0) return true;
    immutable(char)* s = str.ptr;
    immutable(char)* t = &(str[$ - 1]);
    while (s < t)
        if (*s++ != *t--) // ugly
            return false;
    return true;
}

void main() {
    alias isPalindrome4 pali;
    assert(pali(""));
    assert(pali("z"));
    assert(pali("aha"));
    assert(pali("sees"));
    assert(!pali("oofoe"));
    assert(pali("deified"));
    assert(!pali("Deified"));
    assert(pali("amanaplanacanalpanama"));
    assert(pali("ingirumimusnocteetconsumimurigni"));
    //assert(pali("salÃ las"));
}
