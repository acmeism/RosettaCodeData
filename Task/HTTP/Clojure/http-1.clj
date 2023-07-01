(defn get-http [url]
  (let [sc (java.util.Scanner.
	    (.openStream (java.net.URL. url)))]
    (while (.hasNext sc)
      (println (.nextLine sc)))))
(get-http "http://www.rosettacode.org")
