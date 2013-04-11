$$ MODE TUSCRIPT
words = REQUEST ("http://www.puzzlers.org/pub/wordlists/unixdict.txt")

DICT letters create
MODE {}
COMPILE
LOOP word=words
 letters=SPLIT (word,|":?:")
 LOOP letter=letters
  DICT letters ADD/QUIET/COUNT letter
 ENDLOOP
ENDLOOP
ENDCOMPILE
DICT letters unload letter,size,cnt

index    =DIGIT_INDEX (cnt)
index    =REVERSE (index)
letter   =INDEX_SORT (letter,index)
cnt      =INDEX_SORT (cnt,index)
frequency=JOIN (letter," --- ",cnt)

*{frequency}
