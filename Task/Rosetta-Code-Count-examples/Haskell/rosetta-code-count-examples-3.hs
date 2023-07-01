$define RCINDEX "http://rosettacode.org/mw/api.php?format=xml&action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500"
$define RCTASK  "http://rosettacode.org/mw/index.php?action=raw&title="
$define RCUA    "User-Agent: Unicon Rosetta 0.1"
$define RCXUA   "X-Unicon: http://unicon.org/"
$define TASKTOT "* Total Tasks *"
$define TOTTOT  "* Total Headers*"

link strings
link hexcvt

procedure main(A)   # simple single threaded read all at once implementation
    Tasks := table(0)
    every task := taskNames() do {
       Tasks[TASKTOT] +:= 1                            # count tasks
       every lang := languages(task) do {              # count languages
          Tasks[task] +:= 1
          Tasks[TOTTOT] +:= 1
          }
       }
    every insert(O := set(),key(Tasks))                # extract & sort keys
    O := put(sort(O--set(TOTTOT,TASKTOT)),TASKTOT,TOTTOT)  # move totals to end
    every write(k := !O, " : ", Tasks[k]," examples.") # report
end

# Generate task names
procedure taskNames()
    continue := ""
    while \(txt := ReadURL(RCINDEX||continue)) do {
        txt ? {
            while tab(find("<cm ") & find(s :="title=\"")+*s) do
                suspend tab(find("\""))\1
            if tab(find("cmcontinue=")) then {
                continue := "&"||tab(upto(' \t'))
                }
            else break
            }
        }
end

# Generate language headers in a task
procedure languages(task)
    static WS
    initial WS := ' \t'
    page := ReadURL(RCTASK||CleanURI(task))
    page ? while (tab(find("\n==")),tab(many(WS))|"",tab(find("{{"))) do {
               header := tab(find("=="))
               header ? {
                   while tab(find("{{header|")) do {
                       suspend 2(="{{header|",tab(find("}}")))\1
                       }
                   }
               }
end

procedure CleanURI(u)                  #: clean up a URI
    static tr,dxml                     # xml & http translation
    initial {
       tr := table()
       every c := !string(~(&digits++&letters++'-_.!~*()/\'`')) do
          tr[c] := "%"||hexstring(ord(c),2)
       every /tr[c := !string(&cset)] := c
       tr[" "] := "_"                                      # wiki convention
       every push(dxml := [],"&#"||right(ord(c := !"&<>'\""),3,"0")||";",c)
       }

    dxml[1] := u                       # insert URI as 1st arg
    u := replacem!dxml                 # de-xml it
    every (c := "") ||:= tr[!u]        # reencode everything
    c := replace(c,"%3E","'")          # Hack to put single quotes back in
    c := replace(c,"%26quot%3B","\"")  # Hack to put double quotes back in
    return c
end

procedure ReadURL(url)                 #: read URL into string
    page := open(url,"m",RCUA,RCXUA) | stop("Unable to open ",url)
    text := ""
    if page["Status-Code"] < 300 then while text ||:= reads(page,-1)
    else write(&errout,image(url),": ",
                       page["Status-Code"]," ",page["Reason-Phrase"])
    close(page)
    return text
end
