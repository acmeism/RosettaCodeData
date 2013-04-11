$define RCINDEX "http://rosettacode.org/mw/api.php?format=xml&action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500"
$define RCTASK  "http://rosettacode.org/mw/index.php?action=raw&title="
$define RCUA    "User-Agent: Unicon Rosetta 0.1"
$define RCXUA   "X-Unicon: http://unicon.org/"
$define TASKTOT "* Total Tasks *"
$define TOTTOT  "* Total Headers*"

link strings
link hexcvt

procedure main(A)   # simple single threaded read all at once implementation

index := ReadURL(RCINDEX)                              #  1. read the index

pages := []
index ? while tab(find("<cm ") & find(s :="title=\"")+*s) do
   put(pages,tab(find("\"")))                          # 2. extract the pages

Tasks := table(0)
every p := !pages do {                                 # 3. process each page

   if p << A[1] then next                              # for tests on small #s

   page := ReadURL(url := RCTASK||CleanURI(p))
   Tasks[TASKTOT] +:= 1                                # . count pages (tasks)
   every find("=={{header|",page) do {                 # . count headers
      Tasks[p] +:= 1
      Tasks[TOTTOT] +:= 1
      }
   }

every insert(O := set(),key(Tasks))                    # 4. extract & sort keys
O := put(sort(O--set(TOTTOT,TASKTOT)),TASKTOT,TOTTOT)  # move totals at the end

every write(k := !O, " : ", Tasks[k]," examples.")     # 5. report
end

procedure CleanURI(u)                                  #: clean up a URI
static tr,dxml                                         # xml & http translation
initial {
   tr := table()
   every c := !string(~(&digits++&letters++'-_.!~*()/\'')) do
      tr[c] := "%"||hexstring(ord(c),2)
   every /tr[c := !string(&cset)] := c
   tr[" "] := "_"                                      # wiki convention
   every push(dxml := [],"&#"||right(ord(c := !"&<>'\""),3,"0")||";",c)
   }

dxml[1] := u                                           # insert URI as 1st arg
u := replacem!dxml                                     # de-xml it
every (c := "") ||:= tr[!u]                            # reencode everything
return c
end

procedure ReadURL(url)                                 #: read URL into string
write(&errout,"Opening ",image(url))
page := open(url,"m",RCUA,RCXUA) | stop("Unable to open ",url)
text := ""
if page["Status-Code"] < 300 then
   while text ||:= reads(page,-1)
else
   stop(page["Status-Code"]," ",page["Reason-Phrase"])
close(page)
return text
end
