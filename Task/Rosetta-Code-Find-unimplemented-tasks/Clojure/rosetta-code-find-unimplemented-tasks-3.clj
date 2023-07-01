(defn urlencode [s] (URLEncoder/encode s "UTF-8"))
(defn param [p v] (str p (urlencode v)))

(defn get-titles
  ([category]
    (let [urlbase "http://www.rosettacode.org/w/api.php"
          params ["action=query"
                  "list=categorymembers"
                  "format=xml"
                  "cmlimit=200"
                  (param "cmtitle=Category:" category)]
          url (str urlbase "?" (string/join "&" params)]
      (get-titles url nil)))
  ([url continue-at]
    (let [continue-param (if continue-at (param "&cmcontinue=" continue-at))
          [titles continue] (titles-cont (str url continue-param))]
      (if continue
        (lazy-cat titles (get-titles url continue))
        titles))))
