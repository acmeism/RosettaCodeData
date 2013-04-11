$$ MODE TUSCRIPT
setofstrings="this is a set of strings to sort This Is A Set Of Strings To Sort"
unsorted=SPLIT (setofstrings,": :")
PRINT "1. setofstrings unsorted"
index=""
LOOP l=unsorted
PRINT l
length=LENGTH (l),index=APPEND(index,length)
ENDLOOP
index =DIGIT_INDEX (index)
sorted=INDEX_SORT (unsorted,index)
PRINT "2. setofstrings sorted"
*{sorted}
