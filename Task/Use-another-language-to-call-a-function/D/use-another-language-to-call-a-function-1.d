import core.stdc.string;

extern(C) bool query(char *data, size_t *length) pure nothrow {
    immutable text = "Here am I";

    if (*length < text.length) {
        *length = 0; // Also clears length.
        return false;
    } else {
        memcpy(data, text.ptr, text.length);
        *length = text.length;
        return true;
    }
}
