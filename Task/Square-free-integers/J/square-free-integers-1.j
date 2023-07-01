isSqrFree=: (#@~. = #)@q:   NB. are there no duplicates in the prime factors of a number?
filter=: adverb def ' #~ u' NB. filter right arg using verb to left
countSqrFree=: +/@:isSqrFree
thru=: <. + i.@(+ *)@-~     NB. helper verb
