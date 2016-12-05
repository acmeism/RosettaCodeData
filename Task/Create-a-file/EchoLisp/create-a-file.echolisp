;; The file system is the browser local storage
;; It is divided into named stores (directories)
;; "user" is the default (home) store

; before : list of stores
(local-stores) → ("system" "user" "words" "reader" "info" "root")

(local-put-value "output.txt" "") → "output.txt" ; into "user"
(local-make-store "user/docs") → "user/docs"
(local-put-value "output.txt" "" "root") → "output.txt" ; into "root"
(local-make-store 'root/docs) → "root/docs"

; after : list of stores
(local-stores 'root) → ("root" "root/docs")
(local-stores 'user) → ("user" "user/docs")
