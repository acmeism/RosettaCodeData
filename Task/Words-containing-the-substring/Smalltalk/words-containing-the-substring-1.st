'unixdict.txt' asFilename contents
    select:[:word | (word size > 11) and:[word includesString:'the']]
    thenDo:#transcribeCR
