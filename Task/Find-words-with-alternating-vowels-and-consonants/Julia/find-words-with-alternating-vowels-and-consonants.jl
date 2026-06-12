isvowel(c) = c in ['a', 'e', 'i', 'o', 'u'] # NB. leaves out 'α' and similar unicode vowels, and what about y?
onlyodds(f, s) = all(c -> f(c), s[1:2:length(s)]) && !any(c -> f(c), s[2:2:length(s)])
onlyevens(f, s) = !any(c -> f(c), s[1:2:length(s)]) && all(c -> f(c), s[2:2:length(s)])
eitheronlyvowels(w, _) = onlyodds(isvowel, w) || onlyevens(isvowel, w) ? w : ""

foreachword("unixdict.txt", eitheronlyvowels, minlen = 10)
