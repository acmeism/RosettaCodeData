(use 'clojure.string)
(triml "   my string   ")
=> "my string   "
(trimr "   my string   ")
=> "   my string"
(trim " \t\r\n my string \t\r\n  ")
=> "my string"
