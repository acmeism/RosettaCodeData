local(str = 'The quick grey rhino jumped over the lazy green fox.')

// String with first character removed
string_remove(#str,-startposition=1,-endposition=1)

// String with last character removed
string_remove(#str,-startposition=#str->size,-endposition=#str->size)

// String with both the first and last characters removed
string_remove(string_remove(#str,-startposition=#str->size,-endposition=#str->size),-startposition=1,-endposition=1)
