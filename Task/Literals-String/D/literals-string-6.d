// The contents of a token string must be valid code fragments.
auto str = q{int i = 5;};
// The contents here isn't a legal token in D, so it's an error:
auto illegal = q{@?};
