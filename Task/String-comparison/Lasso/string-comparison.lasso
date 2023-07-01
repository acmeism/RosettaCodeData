// Comparing two strings for exact equality
"'this' == 'this': " + ('this' == 'this') // true
"'this' == 'This': " + ('this' == 'This') // true, as it's case insensitive

// Comparing two strings for inequality (i.e., the inverse of exact equality)
"'this' != 'this': " + ('this' != 'this')// false
"'this' != 'that': " + ('this' != 'that') // true

// Comparing two strings to see if one is lexically ordered before than the other
"'alpha' < 'beta': " + ('alpha' < 'beta') // true
"'beta' < 'alpha': " + ('beta' < 'alpha') // false

// Comparing two strings to see if one is lexically ordered after than the other
"'alpha' > 'beta': " + ('alpha' > 'beta') // false
"'beta' > 'alpha': " + ('beta' > 'alpha') // true

// How to achieve both case sensitive comparisons and case insensitive comparisons within the language
"case sensitive - 'this'->equals('This',-case=true): " + ('this'->equals('This',-case=true)) // false
"case insensitive - 'this'->equals('This',-case=true): " + ('this'->equals('This')) // true

// How the language handles comparison of numeric strings if these are not treated lexically
"'01234' == '01234': "+ ('01234' == '01234') // true
"'01234' == '0123': " + ('01234' == '0123') // false
"'01234' > '0123': " + ('01234' > '0123') // true
"'01234' < '0123': " + ('01234' < '0123') //false

// Additional string comparisons
"'The quick brown fox jumps over the rhino' >> 'fox' (contains): " +
    ('The quick brown fox jumps over the rhino' >> 'fox') // true
"'The quick brown fox jumps over the rhino' >> 'cat' (contains): " +
    ('The quick brown fox jumps over the rhino' >> 'cat') // false
"'The quick brown fox jumps over the rhino'->beginswith('rhino'): " +
    ('The quick brown fox jumps over the rhino'->beginswith('rhino')) // false
"'The quick brown fox jumps over the rhino'->endswith('rhino'): " +
    ('The quick brown fox jumps over the rhino'->endswith('rhino')) // true
