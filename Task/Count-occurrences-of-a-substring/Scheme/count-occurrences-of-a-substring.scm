gosh> (use gauche.lazy)
#<undef>
gosh> (length (lrxmatch "th" "the three truths"))
3
gosh> (length (lrxmatch "abab" "ababababab"))
2
