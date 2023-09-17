$ raku -pe '.=trans: {$_ => $_».rotate(13)}({[$_».uc, @$_]}("a".."z"))'
