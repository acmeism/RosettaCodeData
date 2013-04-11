(load "@lib/http.l")

(client "rosettacode.org" 80
   "mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml"
   (while (from " title=\"")
      (let Task (till "\"")
         (client "rosettacode.org" 80 (pack "wiki/" (replace Task " " "_"))
            (let Cnt 0
               (while (from "<span class=\"tocnumber\">")
                  (unless (sub? "." (till "<" T))
                     (inc 'Cnt) ) )
               (out NIL (prinl (ht:Pack Task) ": " Cnt)) ) ) ) ) )
