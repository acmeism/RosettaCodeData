bagOfWords := Bag new.
'unixdict.txt' asFilename contents
    select:[:word | (word size > 11) and:[word includesString:'the']]
    thenDo:[:word | bagOfWords add:word. word transcribeCR].

bagOfWords transcribeCR.
bagOfWords size transcribeCR
