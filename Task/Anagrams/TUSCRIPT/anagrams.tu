$$ MODE TUSCRIPT,{}
requestdata = REQUEST ("http://www.puzzlers.org/pub/wordlists/unixdict.txt")

DICT anagramm CREATE 99999

COMPILE
 LOOP word=requestdata
  -> ? : any character
  charsInWord=STRINGS (word," ? ")
  charString =ALPHA_SORT (charsInWord)
  DICT anagramm APPEND/QUIET/COUNT charString,num,freq,word;" "
 ENDLOOP

DICT anagramm UNLOAD charString,all,freq,anagrams

index        =DIGIT_INDEX (freq)
reverseIndex =REVERSE (index)
freq         =INDEX_SORT (freq,reverseIndex)
anagrams     =INDEX_SORT (anagrams,reverseIndex)
charString   =INDEX_SORT (charString,reverseIndex)

mostWords=SELECT (freq,1), adjust=MAX_LENGTH (charString)
 LOOP cs=charString, f=freq, a=anagrams
  IF (f<mostWords) EXIT
   cs=CENTER (cs,-adjust)
   PRINT cs," ",f,": ",a
 ENDLOOP
ENDCOMPILE
