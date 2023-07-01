(if-not (empty? (filter #(and (not (nil? %)) (.contains (.toUpperCase %) "UTF"))
  (map #(System/getenv %) ["LANG" "LC_ALL" "LC_CTYPE"])))
    "Unicode is supported on this terminal and U+25B3 is : \u25b3"
    "Unicode is not supported on this terminal.")
