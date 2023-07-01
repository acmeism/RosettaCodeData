(defn make-mailing-label [{:keys [name address country]}]
  "Returns the correct text to mail a letter to the addressee"
  (str name "\n" address "\n" (or country "UK"))) ;; If country is nil, assume it is the UK

;; We can call it with all three arguments in a map to get mickey's international address
(make-mailing-label {:name "Mickey Mouse"
                     :address "1 Disney Avenue, Los Angeles"
                     :country "USA"}); => "Mickey Mouse\n1 Disney Avenue, Los Angeles\nUSA"

;; Or we can call it with fewer arguments for domestic mail
(make-mailing-label {:name "Her Majesty"
                     :address "Buckingham Palace, London"}); => "Her Majesty\nBuckingham Palace, London\nUK"
