(require '[clojure.java.jdbc :as sql])
; Using h2database for this simple example.
(def db {:classname "org.h2.Driver"
         :subprotocol "h2:file"
         :subname "db/my-dbname"})

(sql/update! db :players {:name "Smith, Steve" :score 42 :active true} ["jerseyNum = ?" 99])

; As an alternative to update!, use execute!
(sql/execute! db ["UPDATE players SET name = ?, score = ?, active = ? WHERE jerseyNum = ?" "Smith, Steve" 42 true 99])
