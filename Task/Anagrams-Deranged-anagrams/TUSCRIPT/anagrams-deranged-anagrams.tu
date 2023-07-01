$$ MODE TUSCRIPT,{}
requestdata = REQUEST ("http://www.puzzlers.org/pub/wordlists/unixdict.txt")

DICT anagramm CREATE 99999

COMPILE
 LOOP word=requestdata
  -> ? : any character
  charsInWord=STRINGS (word," ? ")
  charString =ALPHA_SORT (charsInWord)

  DICT anagramm LOOKUP charString,num,freq,wordalt,wlalt
  IF (num==0) THEN
   WL=SIZE (charString)
   DICT anagramm APPEND/QUIET/COUNT charString,num,freq,word,wl;" "
  ELSE
   DICT anagramm APPEND/QUIET/COUNT charString,num,freq,word,"";" "
  ENDIF
 ENDLOOP

DICT anagramm UNLOAD charString,all,freq,anagrams,wl

index        =DIGIT_INDEX (wl)
reverseIndex =REVERSE (index)
wl           =INDEX_SORT (wl,reverseIndex)
freq         =INDEX_SORT (freq,reverseIndex)
anagrams     =INDEX_SORT (anagrams,reverseIndex)
charString   =INDEX_SORT (charString,reverseIndex)

LOOP fr=freq,a=anagrams,w=wl
 IF (fr==1) cycle
 asplit=SPLIT (a,": :")
 a1=SELECT (asplit,1,arest)
 a1split=STRINGS (a1," ? ")
 LOOP r=arest
  rsplit=STRINGS (r," ? ")
   LOOP v1=a1split,v2=rsplit
    IF (v1==v2) EXIT,EXIT
   ENDLOOP
    PRINT "Largest deranged anagram (length: ",w,"):"
    PRINT a
   STOP
 ENDLOOP
ENDLOOP
ENDCOMPILE
