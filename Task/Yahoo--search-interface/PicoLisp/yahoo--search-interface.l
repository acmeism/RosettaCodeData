(load "@lib/http.l")

(de yahoo (Query Page)
   (default Page 1)
   (client "search.yahoo.com" 80
      (pack
         "search?p=" (ht:Fmt Query)
         "&b=" (inc (* 10 (dec Page))) )
      (make
         (while (from "<a class=\"yschttl spt\" href=\"")
            (link
               (make
                  (link (till "\"" T))       # Url
                  (from "<b>")
                  (link (till "<" T))        # Title
                  (from "class=\"abstr\"")
                  (from ">")
                  (link                      # Content
                     (pack
                        (make
                           (loop
                              (link (till "<" T))
                              (T (eof))
                              (T (= "</div" (till ">" T)))
                              (char) ) ) ) ) ) ) ) ) ) )
