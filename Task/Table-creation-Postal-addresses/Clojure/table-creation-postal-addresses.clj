(require '[clojure.java.jdbc :as sql])
; Using h2database for this simple example.
(def db {:classname "org.h2.Driver"
         :subprotocol "h2:file"
         :subname "db/my-dbname"})

(sql/db-do-commands db
  (sql/create-table-ddl :address
    [:id "bigint primary key auto_increment"]
    [:street "varchar"]
    [:city "varchar"]
    [:state "varchar"]
    [:zip "varchar"]))
