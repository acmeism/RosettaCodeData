$$ MODE TUSCRIPT,{}
requestdata = REQUEST ("http://www.puzzlers.org/pub/wordlists/unixdict.txt")
DICT semordnilap CREATE 99999
COMPILE
LOOP r=requestdata
rstrings=STRINGS(r," ? ")
rreverse=REVERSE(rstrings)
revstring=EXCHANGE (rreverse,":'':':'::")
group=APPEND (r,revstring)
sort=ALPHA_SORT (group)
DICT semordnilap APPEND/QUIET/COUNT sort,num,cnt,"",""
ENDLOOP
DICT semordnilap UNLOAD wordgroups,num,howmany
get_palins=FILTER_INDEX (howmany,-," 1 ")
size=SIZE(get_palins)
PRINT "unixdict.txt contains ", size, " palindromes"
PRINT " "
palindromes=SELECT (wordgroups,#get_palins)
LOOP n=1,5
take5=SELECT (palindromes,#n)
PRINT n,". ",take5
ENDLOOP
ENDCOMPILE
