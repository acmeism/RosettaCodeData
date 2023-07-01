(load "@lib/http.l" "@lib/xm.l")

(de rosettaCategory (Cat)
   (let (Cont NIL  Xml)
      (make
         (loop
            (client "rosettacode.org" 80
               (pack
                  "mw/api.php?action=query&list=categorymembers&cmtitle=Category:"
                  Cat
                  "&cmlimit=200&format=xml"
                  Cont )
               (while (line))
               (setq Xml (and (xml?) (xml))) )
            (NIL Xml)
            (for M (body Xml 'query 'categorymembers)
               (link (attr M 'title)) )
            (NIL (attr Xml 'query-continue' categorymembers 'cmcontinue))
            (setq Cont (pack "&cmcontinue=" @)) ) ) ) )

(de unimplemented (Task)
   (diff
      (rosettaCategory "Programming_Tasks")
      (rosettaCategory Task) ) )
