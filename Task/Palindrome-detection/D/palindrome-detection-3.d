import std.stdio, core.exception, std.traits;

// assume alloca() to be pure for this program
extern(C) pure nothrow void* alloca(in size_t size);

bool isPalindrome3(C)(in C[] s) pure if (isSomeChar!C) {
    auto p = cast(dchar*)alloca(s.length * 4);
    if (p == null)
        // no fallback heap allocation used
        throw new OutOfMemoryError();
    dchar[] dstr = p[0 .. s.length];

    // use std.utf.stride for an even lower level version
    int i = 0;
    foreach (dchar c; s) { // not nothrow
        dstr[i] = c;
        i++;
    }
    dstr = dstr[0 .. i];

    foreach (j; 0 .. dstr.length / 2)
        if (dstr[j] != dstr[$ - j - 1])
            return false;
    return true;
}

void main() {
    alias isPalindrome3 pali;
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
