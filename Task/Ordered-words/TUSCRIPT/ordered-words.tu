$$ MODE TUSCRIPT
SET data = REQUEST ("http://www.puzzlers.org/pub/wordlists/unixdict.txt")
DICT orderdwords CREATE 99999
COMPILE
LOOP word=data
 - "<%" = any token
 SET letters=STRINGS (word,":<%:")
 SET wordsignatur= ALPHA_SORT (letters)
 IF (wordsignatur==letters) THEN
  SET wordlength=LENGTH (word)
  DICT orderdwords ADD/COUNT word,num,cnt,wordlength
 ENDIF
ENDLOOP

DICT orderdwords UNLOAD words,num,cnt,wordlength
SET maxlength=MAX_LENGTH (words)
SET rtable=QUOTES (maxlength)
BUILD R_TABLE maxlength = rtable
SET index=FILTER_INDEX (wordlength,maxlength,-)
SET longestwords=SELECT (words,#index)
PRINT num," ordered words - max length is ",maxlength,":"

LOOP n,w=longestwords
SET n=CONCAT (n,"."), n=CENTER(n,4)
PRINT n,w
ENDLOOP
ENDCOMPILE
