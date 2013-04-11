$$ MODE TUSCRIPT
url="http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml"
data=REQUEST (url)

BUILD S_TABLE beg=*
DATA :title=":
BUILD S_TABLE end=*
DATA :":

titles=EXTRACT (data,beg|,end,1,0,"~~")
titles=SPLIT (titles,":~~:")
sz_titles=SIZE (titles)

BUILD R_TABLE header=":==\{\{header|:"
all=*

ERROR/STOP CREATE ("tasks",seq-e,-std-)

COMPILE
LOOP title=titles
ask=*
ask      =SET_VALUE(ask,"title",title)
ask      =SET_VALUE(ask,"action","raw")
ask      =ENCODE (ask,cgi)
http     ="http://www.rosettacode.org/mw/index.php"
url      =CONCAT (http,"?",ask)
data     =REQUEST (url)
header   =FILTER_INDEX (data,header,-)
sz_header=SIZE(header)
line     =CONCAT (title,"=",sz_header," members")
FILE "tasks" = line
all      =APPEND(all,sz_header)
ENDLOOP

ENDCOMPILE
all =JOIN(all),sum=SUM(all),time=time()
line=CONCAT (time,": ", sz_titles, " Programing Tasks: ", sum, " solutions")

FILE "tasks" = line
